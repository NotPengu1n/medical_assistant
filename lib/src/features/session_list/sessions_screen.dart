import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:medical_assistant/src/app/app_navigation.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/features/cabinets/cabinet.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_screen.dart';
import 'package:medical_assistant/src/features/menu/BottomMenu.dart';
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
  late Set<Cabinet> cabinets;

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
    super.dispose();
  }

  void refreshSessions() {
    sessions = Synchronization.getSessions(_selectedDate);
    sessions.then((value) {
      cabinets.clear();

      for (var session in value) {
        Cabinet cabinet = Cabinet.fromMap(session["Кабинет"]);
        cabinets.add(cabinet);
      }
    });
  }

  // Список сеансов
  Widget BodyList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: sessions,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('${S.of(context).error}: ${snapshot.error}'),
          );
        }

        final data = snapshot.data ?? [];

        return RefreshIndicator(
          onRefresh: () {
            setState(() {
              refreshSessions();
            });
            return sessions;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Шапка
              ...scrollingHeader(context),

              // Список сеансов / загрузка / пустое сообщение
              ...sessionCardWidgets(context, snapshot, data),

              // Отступ
              SliverToBoxAdapter(child: SizedBox(height: 150)),
            ],
          ),
        );
      },
    );
  }

  // Список сеансов / загрузка / пустое сообщение
  List<Widget> sessionCardWidgets(context, snapshot, data) {
    return [
      if (snapshot.connectionState == ConnectionState.waiting) ...[
        SliverToBoxAdapter(child: SizedBox(height: 150)),
        SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
      ] else if (data.isEmpty) ...[
        SliverToBoxAdapter(
          child: Center(child: Text(S.of(context).emptySessions)),
        ),
      ] else ...[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => SessionCard(session: data[index]),
            childCount: data.length,
          ),
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          S.of(context).sessions,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: BodyList()),
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
        splashColor: Colors.blue.withOpacity(0.2),
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
      child: Text("Выбрать рабочие кабинеты"),
    );
  }

  List<Widget> scrollingHeader(BuildContext context) {
    return [
      SliverToBoxAdapter(child: buttonSelectWorkCabinets(context)),

      //SliverToBoxAdapter(child: buildCabinetsSelector(context)),

      SliverToBoxAdapter(
        child: DateSlider(
          onDateSelected: (date) {
            if (date.beginOfDay() == _selectedDate) return;
            print('Выбрана дата: ${date.toString()}');
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

  Widget buildCabinetsSelector(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cabinets.length,
        itemBuilder: (context, index) {
          final cabinet = cabinets.elementAt(index);
          final isSelected = cabinet.isSelected ?? false;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilterChip(
              label: Text(cabinet.toString()),
              selected: isSelected,
              onSelected: (selected) {
                // При выборе нового, снимаем выбор со всех
                final newCabinets = Set<Cabinet>.from(cabinets);
                for (var c in newCabinets) {
                  c.isSelected = false;
                }
                if (selected) {
                  cabinet.isSelected = true;
                }
                //onSelectionChanged(selected ? cabinet : null);
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
