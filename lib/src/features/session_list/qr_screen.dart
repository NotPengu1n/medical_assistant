

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_assistant/src/features/cabinets/cabinet.dart';
import 'package:medical_assistant/src/features/services/service.dart';
import 'package:medical_assistant/src/features/session_list/assigned_session.dart';
import 'package:medical_assistant/src/features/session_list/sessions_widget_list.dart';
import 'package:medical_assistant/ui_kit/ui_kit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// TODO: вынести в отдельный файл
class QRScanButton extends StatelessWidget {
  final Future<List<AssignedSession>> sessions;
  final ValueNotifier<Cabinet?> selectedCabinet;
  final ValueNotifier<Service?> selectedService;

  QRScanButton({
    super.key,
    required this.sessions,
    required this.selectedService,
    required this.selectedCabinet
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 90,
      child: FloatingActionButton(
        onPressed: () {
          print('tap');
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => QRScanScreen(sessions: sessions, selectedCabinet: selectedCabinet, selectedService: selectedService,),
            ),
          );
        },
        backgroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 8,
        splashColor: AppT.c.primary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppT.c.primary,
                AppT.c.primary,
              ],
            ),
          ),
          padding: const EdgeInsets.all(5),
          child: const Icon(
            Icons.qr_code_2_rounded,
            color: Colors.white,
            size: 70,
          ),
        ),
      ),
    );
  }
}

// Форма отметки сканированием
class QRScanScreen extends StatefulWidget {
  final Future<List<AssignedSession>> sessions;
  final ValueNotifier<Cabinet?> selectedCabinet;
  final ValueNotifier<Service?> selectedService;
  String? qrData;

  QRScanScreen({
    super.key,
    required this.sessions,
    required this.selectedService,
    required this.selectedCabinet
  });

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [
      BarcodeFormat.qrCode,
    ],
  );

  String? _scannedValue;
  bool _isProcessing = false;

  Set<String> scanned = {};
  int countBefore = 0; // Если количество изменилось, то издаем вибрацию.

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? value = barcodes.first.rawValue;
    if (value == null || value.isEmpty) return;

    _isProcessing = true;
    scanned.add(value);

    setState(() {
      _scannedValue = value;
      widget.qrData = _scannedValue;
    });

    // Пауза сканирования
    Future.delayed(const Duration(milliseconds: 700), () {
      _isProcessing = false;
    });
  }

  List<AssignedSession> _filterSessions(List<AssignedSession> data) {
    if (widget.qrData == null || widget.qrData!.isEmpty) {
      return []; // Нет данных qr-кода = ничего не отображаем
    }

    final qrValue = widget.qrData!.toString();

    return data.where((session) {
      final medicalCardId = session.medicalCard?["Идентификатор"]?.toString();

      final guestCardId = session.guestCard?["Идентификатор"]?.toString();

      return medicalCardId == qrValue || guestCardId == qrValue;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppT.c.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppT.c.primary,
        title: const Text('Сканирование QR-кода', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: () {
              _scannerController.toggleTorch();
            },
          ),
        ],
      ),
      body: Padding(padding: EdgeInsetsGeometry.only(bottom: 20), child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 260,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: _handleDetection,
                    ),
                    IgnorePointer(
                      child: Center(
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    counter(scanned.length)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AssignedSession>>(
              future: widget.sessions,
              builder: (context, snapshot) {
                final data = snapshot.data ?? <AssignedSession>[];
                final filteredData = _filterSessions(data);

                return CustomScrollView(
                  slivers: [
                    ...SessionsWidgetList.sessionCardWidgets(context, snapshot, filteredData, refresh, showCompleted: true,
                        selectedCabinet: widget.selectedCabinet, selectedService: widget.selectedService,
                        afterFilter: markSingleSession // Дополнительная фильтрация списка происходит внутри, поэтому делаем так
                    )
                  ],
                );
              },
            ),
          ),
        ],
      )
      ),
    );
  }

  // Автоматически выполняем отметку, если сеанс единственный
  void markSingleSession(List<AssignedSession> data) {
    if (data.length == 1) {
      if (countBefore != scanned.length) {
        vibrateShort();
        countBefore++;
      }
      data[0].handleSessionAction(isCancel: false, updateState: () {});
    }
  }

  Future<void> vibrateShort() async {
    await HapticFeedback.heavyImpact();
  }

  // Счетчик отсканированных
  Widget counter(int count) {
    return Positioned(
      right: 12,
      bottom: 12,
      child: TweenAnimationBuilder<double>(
        key: ValueKey(count),
        tween: Tween(begin: 1.12, end: 1.0),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  setState(() {
                    scanned.clear(); // Очищаем количество при нажатии
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppT.c.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}