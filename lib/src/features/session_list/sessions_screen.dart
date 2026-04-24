import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/app/app_navigation.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/data/auth_data_manager.dart';
import 'package:medical_assistant/src/features/cabinets/cabinet.dart';
import 'package:medical_assistant/src/features/services/service.dart';
import 'package:medical_assistant/src/features/session_list/assigned_session.dart';
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
  late Future<List<AssignedSession>> sessions;

  final cabinets = SplayTreeSet<Cabinet>(
        (a, b) => a.name!.compareTo(b.name!),
  );
  ValueNotifier<Cabinet?> selectedCabinet = ValueNotifier(null);
  final services = SplayTreeSet<Service>(
        (a, b) => a.name!.compareTo(b.name!),
  );
  ValueNotifier<Service?> selectedService = ValueNotifier(null);

  bool showPassed = false;

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
          Cabinet cabinet = Cabinet.fromMap(session.room!);
          cabinets.add(cabinet);

          Service service = Service.fromMap(session.service!);
          services.add(service);
        }
      });
    });
  }

  // Список сеансов
  Widget bodyList() {
    return FutureBuilder<List<AssignedSession>>(
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
              ...SessionsWidgetList.sessionCardWidgets(context, snapshot, data, refresh,
                  selectedCabinet: selectedCabinet, selectedService: selectedService, showCompleted: showPassed),

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
          actions: menu()
      ),
      body: Column(
        children: [
          Expanded(child: bodyList()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: bottomMenu(context),
    );
  }

  // Меню приложения. // TODO: В отдельный класс надо вынести.
  List<Widget> menu() {
    return [
      IconButton(
        icon: Icon(Icons.menu, color: AppT.c.surface),
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                backgroundColor: AppT.c.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder<String>(
                            future: AuthDataManager.getEmployeeName(),
                            builder: (_, snapshot) => Text(
                              snapshot.data ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppT.c.surface)
                            ),
                          ),

                          buttonShowCompleted(context, setStateDialog),

                          const SizedBox(height: 8),

                          Container(
                            margin: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                            decoration: BoxDecoration(
                              color: AppT.c.surface.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppT.c.surface.withOpacity(0.12),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buttonOpenRenderedServices(context),

                                Divider(height: 1, color: AppT.c.surface.withOpacity(0.1)),

                                buttonSelectWorkCabinets(context),

                                Divider(height: 1, color: AppT.c.surface.withOpacity(0.1)),

                                buttonChangeUser(context),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    ];
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
  Widget bottomMenu(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          QRScanButton(sessions: sessions, selectedService: selectedService, selectedCabinet: selectedCabinet),
          Positioned(
            left: 16,
            child: _buildScrollTopButton(),
          ),
        ],
      ),
    );
  }

  // Флажок "Показывать пройденные"
  Widget buttonShowCompleted(BuildContext context, setStateDialog) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          showPassed = !showPassed;
        });
        setStateDialog(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppT.c.surface.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppT.c.surface.withOpacity(0.12)
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.show_completed,
                    style: TextStyle(
                      color: AppT.c.surface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 46,
                  height: 26,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppT.c.surface.withOpacity(0.4),
                  ),
                  child: Align(
                    alignment: showPassed
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: showPassed
                            ? AppT.c.primary
                            : AppT.c.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: showPassed ? 0.06 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppT.c.primary,
                ),
              ),
            ),
          ],
        ),
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

  // Кнопка открытия отчета "Оказанные услуги"
  Widget buttonOpenRenderedServices(BuildContext context){
    return TextButton(
        onPressed: () => {AppNavigation.openRenderedServices(context)},
        child: Text(AppLocalizations.of(context)!.rendered_sessions, style: TextStyle(color: AppT.c.surface),),
    );
  }

  // Кнопка смены пользователя
  Widget buttonChangeUser(BuildContext context){
    return TextButton(
        onPressed: () async {
          await AuthDataManager.logout();
          AppNavigation.openLogin(context);
        },
        child: Text(AppLocalizations.of(context)!.change_user, style: TextStyle(color: AppT.c.surface))
    );
  }

  // Шапка списка (выбор кабинета, выбор услуги, выбор даты)
  List<Widget> scrollingHeader(BuildContext context) {
    return [
      SliverToBoxAdapter(child: buildCabinetsSelector(context)),

      SliverToBoxAdapter(child: buildServicesSelector(context)),

      SliverToBoxAdapter(child: const SizedBox(height: 10)),

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

    if (items.length <= 1) return const SizedBox.shrink();

    return Container(
        margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: ValueListenableBuilder<T?>(
          valueListenable: selector,
          builder: (context, selectedValue, _) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(items.length, (index) {
                  final elem = items[index];
                  final isSelected = elem == selectedValue;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (elem == selector.value) {
                            selector.value = null;
                          } else {
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
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? AppT.c.primary : AppT.c.surface,
                              width: 1,
                            ),
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? AppT.c.surface
                                  : AppT.c.textPrimary,
                            ),
                            child: Text(
                              elem.toString(),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        )
    );
  }

  void refresh() {
    setState(() {});
  }
}
