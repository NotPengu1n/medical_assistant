import 'package:flutter/material.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/app/app_navigation.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/features/cabinets/cabinet.dart';
import 'package:medical_assistant/src/features/services/service.dart';
import 'package:medical_assistant/src/features/session_list/date_slider.dart';
import 'package:medical_assistant/src/features/session_list/qr_screen.dart';
import 'package:medical_assistant/src/features/session_list/sessions_widget_list.dart';
import 'package:medical_assistant/src/network/synchronization.dart';
import 'package:medical_assistant/ui_kit/ui_kit.dart';

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
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    refreshSessions();

    Synchronization.getEmployee("Мобильная медсестра");

    _scrollController = ScrollController();
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
              ...SessionsWidgetList.sessionCardWidgets(context, snapshot, data, refresh, selectedCabinet: selectedCabinet, selectedService: selectedService),

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppT.c.background,
      appBar: AppBar(
        backgroundColor: AppT.c.primary,
        title: Text(
          AppLocalizations.of(context)!.sessions,
          style: TextStyle(color: AppT.c.surface),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: AppT.c.surface),
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: AppT.c.primary,
                context: context,
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buttonOpenRenderedServices(context),
                        buttonSelectWorkCabinets(context),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ]
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
                  backgroundColor: AppT.c.divider,
                  child: Icon(Icons.arrow_upward, color: AppT.c.primary),
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
      //color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          QRScanButton(sessions: sessions),
          Positioned(
            left: 16,
            child: _buildScrollTopButton(),
          ),
        ],
      ),
    );
  }

  // Кнопка для выбора кабинетов
  Widget buttonSelectWorkCabinets(BuildContext context) {
    return TextButton(
      onPressed: () => {AppNavigation.openCabinets(context)},
      child: Text(AppLocalizations.of(context)!.choose_cabinets, style: TextStyle(color: AppT.c.surface))
    );
  }

  Widget buttonOpenRenderedServices(BuildContext context){
    return TextButton(
        onPressed: () => {AppNavigation.openRenderedServices(context)},
        child: Text(AppLocalizations.of(context)!.rendered_sessions, style: TextStyle(color: AppT.c.surface),),
    );
  }

  List<Widget> scrollingHeader(BuildContext context) {
    return [
      //SliverToBoxAdapter(child: buttonOpenRenderedServices(context)),

      //SliverToBoxAdapter(child: buttonSelectWorkCabinets(context)),

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
                            color: isSelected ? AppT.c.primary : AppT.c.surface,
                            borderRadius: BorderRadius.circular(18), // TODO: Сделать как везде
                            border: Border.all(
                              color: isSelected
                                  ? AppT.c.primary
                                  : AppT.c.surface,
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
                              color: isSelected ? AppT.c.surface : AppT.c.textPrimary,
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

  void refresh() {
    setState(() {});
  }
}
