import 'package:flutter/material.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/app/app_navigation.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/features/cabinets/cabinet.dart';
import 'package:medical_assistant/src/features/services/service.dart';
import 'package:medical_assistant/src/features/session_list/date_slider.dart';
import 'package:medical_assistant/src/features/session_list/session_card.dart';
import 'package:medical_assistant/src/network/synchronization.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionScreen();
}

class _SessionScreen extends State<SessionsScreen> {
  DateTime _selectedDate = DateTime.now().beginOfDay();
  late Future<List<Map<String, dynamic>>> sessions;

  Set<Cabinet> cabinets = Set<Cabinet>();
  ValueNotifier<Cabinet?> selectedCabinet = ValueNotifier(null);
  Set<Service> services = Set<Service>();
  ValueNotifier<Service?> selectedService = ValueNotifier(null);

  final ValueNotifier<bool> _showScrollButton = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    refreshSessions();

    _scrollController.addListener(() {
      _showScrollButton.value = _scrollController.offset > 200;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showScrollButton.dispose();
    selectedCabinet.dispose();
    selectedService.dispose();
    super.dispose();
  }

  void refreshSessions() {
    sessions = Synchronization.getSessions(_selectedDate);
    sessions.then((value) {
      cabinets.clear();
      services.clear();

      if (!mounted) return;

      setState(() { // Как-то тупо вызывать это в initState(), но в этом я не уверен.
        for (var session in value) {
          Cabinet cabinet = Cabinet.fromMap(session["Кабинет"]);
          cabinets.add(cabinet);

          Service service = Service.fromMap(session["Услуга"]);
          services.add(service);
        }
      });
    });
  }

  // Список сеансов
  Widget bodyList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: sessions,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
            ),
          );
        }

        final data = snapshot.data ?? [];

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              refreshSessions();
            });
            await sessions;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Шапка
              ...scrollingHeader(context),

              // Список / загрузка / пустое состояние
              ...sessionCardWidgets(context, snapshot, data),

              // Отступ снизу
              const SliverToBoxAdapter(
                child: SizedBox(height: 150),
              ),
            ],
          ),
        );
      },
    );
  }

// Список сеансов / загрузка / пустое сообщение
  List<Widget> sessionCardWidgets(BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot, List<Map<String, dynamic>> data) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const [
        SliverToBoxAdapter(
          child: SizedBox(height: 150),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ];
    }

    if (data.isEmpty) {
      return [
        emptySessionWidget(context),
      ];
    }

    final filteredData = data.where((session) {
      final cabinetOk = selectedCabinet.value == null ||
          Cabinet.fromMap(session['Кабинет']) == selectedCabinet.value;

      final serviceOk = selectedService.value == null ||
          Service.fromMap(session['Услуга']) == selectedService.value;

      return cabinetOk &&
          serviceOk &&
          !(session["isPassed"] == true || session["isNoShow"] == true);
    }).toList();

    if (filteredData.isEmpty) {
      return [
        emptySessionWidget(context),
      ];
    }

    filteredData.sort((a, b) => a["ВремяС"].compareTo(b["ВремяС"]));

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return SessionCard(session: filteredData[index]);
          },
          childCount: filteredData.length,
        ),
      ),
    ];
  }

  SliverToBoxAdapter emptySessionWidget(context) {
    return SliverToBoxAdapter(
      child: Center(
          child: Text(AppLocalizations.of(context)!.emptySessions)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          AppLocalizations.of(context)!.sessions,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: bodyList()),
          //const SizedBox(height: 100,)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomMenu(context),
    );
  }

  // Кнопка пролистывания вверх
  Widget _buildScrollTopButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showScrollButton,
      builder: (context, show, child) {
        return AnimatedOpacity(
          opacity: show ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: show
              ? FloatingActionButton.small(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.arrow_upward, color: Colors.blue),
                )
              : SizedBox.shrink(),
        );
      },
    );
  }

  // Нижнее прикрепленное меню
  Widget BottomMenu(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          buildQRScanButton(context),
          Positioned(
            left: 16,
            child: _buildScrollTopButton(),
          ),
        ],
      ),
    );
  }

  // Кнопка сканирования карты гостя
  Widget buildQRScanButton(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      child: FloatingActionButton(
        onPressed: () {
          // TODO: Добавить логику сканирования QR-кода
          print('Сканирование QR-кода');
        },
        backgroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 8,
        splashColor: Colors.blue.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Color.fromRGBO(0, 105, 217, 1), // Более темный синий
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

  // Кнопка для выбора кабинетов
  Widget buttonSelectWorkCabinets(BuildContext context) {
    return TextButton(
      onPressed: () => {AppNavigation.openCabinets(context)},
      child: Text("Выбрать рабочие кабинеты")
    );
  }

  Widget buttonOpenRenderedServices(BuildContext context){
    return TextButton(
        onPressed: () => {AppNavigation.openRenderedServices(context)},
        child: Text("Оказанные услуги")
    );
  }

  List<Widget> scrollingHeader(BuildContext context) {
    return [
      SliverToBoxAdapter(child: buttonOpenRenderedServices(context)),

      SliverToBoxAdapter(child: buttonSelectWorkCabinets(context)),

      SliverToBoxAdapter(child: buildCabinetsSelector(context)),

      SliverToBoxAdapter(child: buildServicesSelector(context)),

      SliverToBoxAdapter(
        child: DateSlider(
          onDateSelected: (date) {
            if (date.beginOfDay() == _selectedDate) return;
            setState(() {
              _selectedDate = date.beginOfDay();
              refreshSessions();
            });
          },
          initialDate: DateTime.now(),
        ),
      ),
    ];
  }

  // Список выбора кабинетов
  Widget buildCabinetsSelector(BuildContext context) {
    return selectorList<Cabinet>(cabinets, selectedCabinet);
  }

  // Список выбора услуг
  Widget buildServicesSelector(BuildContext context) {
    return selectorList<Service>(services, selectedService);
  }

  // Горизонтальный список выбора
  Widget selectorList<T>(Set<T> list, ValueNotifier<T?> selector) {
    final items = list.toList();

    return Container(
        margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: SizedBox(
          height: 50,
          child: ValueListenableBuilder<T?>(
            valueListenable: selector,
            builder: (context, selectedValue, _) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final elem = items[index];
                  final isSelected = elem == selectedValue;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 6),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (elem == selector.value) {
                            selector.value = null;
                          }
                          else {
                            selector.value = elem;
                          }
                        });
                      },
                      child: AnimatedScale(
                        scale: isSelected ? 1.0 : 0.96,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey
                                .shade100,
                            borderRadius: BorderRadius.circular(18), // TODO: Сделать как везде
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              width: 1,
                            )
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            child: Text(elem.toString()),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )
    );
  }
}
