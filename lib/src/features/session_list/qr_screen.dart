import 'package:flutter/material.dart';
import 'package:medical_assistant/src/features/session_list/sessions_screen.dart';
import 'package:medical_assistant/src/features/session_list/sessions_widget_list.dart';
import 'package:medical_assistant/ui_kit/ui_kit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanButton extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> sessions;

  const QRScanButton({
    super.key,
    required this.sessions,
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
              builder: (_) => QRScanScreen(sessions: sessions),
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

class QRScanScreen extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> sessions;
  String? qrData;

  QRScanScreen({
    super.key,
    required this.sessions,
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

    setState(() {
      _scannedValue = value;
      widget.qrData = _scannedValue;
    });

    // Пауза сканирования
    Future.delayed(const Duration(milliseconds: 700), () {
      _isProcessing = false;
    });
  }

  List<Map<String, dynamic>> _filterSessions(List<Map<String, dynamic>> data) {
    if (widget.qrData == null || widget.qrData!.isEmpty) {
      return []; // Нет данных qr-кода = ничего не отображаем
    }

    final qrValue = widget.qrData!.toString();

    return data.where((session) {
      final medicalCardId =
      session["МедицинскаяКарта"]?["Идентификатор"]?.toString();

      final guestCardId =
      session["КартаГостя"]?["Идентификатор"]?.toString();

      return medicalCardId == qrValue || guestCardId == qrValue;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    if (_scannedValue != null)
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Считано: $_scannedValue',
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: widget.sessions,
              builder: (context, snapshot) {
                final data = snapshot.data ?? <Map<String, dynamic>>[];
                final filteredData = _filterSessions(data);

                return CustomScrollView(
                  slivers: [
                    ...SessionsWidgetList.sessionCardWidgets(context, snapshot, filteredData, refresh)
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

  void refresh() {
    setState(() {});
  }
}