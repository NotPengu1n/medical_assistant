import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';

class DateSlider extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final DateTime? initialDate;
  final double itemWidth = 70;
  final double itemHeight = 55;

  DateSlider({Key? key, this.onDateSelected, this.initialDate})
    : super(key: key);

  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  late DateTime _selectedDate;
  DateTime? calendarSelectedDate;
  late List<DateTime> _dates;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initDates();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _initDates() {
    _dates = [];
    final now = DateTime.now();

    // Позавчера, вчера, сегодня, завтра, выбрать день.
    for (int i = -2; i <= 1; i++) {
      _dates.add(DateTime(now.year, now.month, now.day + i));
    }
  }

  void _scrollToSelectedDate() {
    final index = _dates.indexWhere((date) => _isSameDay(date, _selectedDate));

    if (index != -1) {
      _scrollController.animateTo(
        (index * (widget.itemWidth + 8)).clamp(
          0,
          _scrollController.position.maxScrollExtent,
        ),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.itemHeight,
      color: Colors.transparent,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dates.length + 1,
        itemBuilder: (context, index) {
          if (index == _dates.length) {
            return calendarButton(context);
          }

          final date = _dates[index];
          final isSelected = _isSameDay(date, _selectedDate);
          final isToday = _isToday(date);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: _DateItem(
              date: date,
              isSelected: isSelected,
              isToday: isToday,
              width: widget.itemWidth,
              height: widget.itemHeight,
              onTap: () {
                setState(() {
                  _selectedDate = date;
                  calendarSelectedDate = null;
                });
                //_scrollToSelectedDate();
                widget.onDateSelected?.call(date);
              },
            ),
          );
        },
      ),
    );
  }

  // Кнопка выбора даты из календаря
  Widget calendarButton(BuildContext context) {
    final isSelected =
        calendarSelectedDate != null && _isSameDay(calendarSelectedDate!, _selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            locale: PlatformDispatcher.instance.locale,
          );

          if (pickedDate != null) {
            setState(() {
              _selectedDate = pickedDate;
              calendarSelectedDate = pickedDate;
            });

            widget.onDateSelected?.call(pickedDate);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.itemWidth,
          height: widget.itemHeight,
          decoration: cardDecoration(isSelected),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_sharp,
                size: 18,
                color: isSelected ? Colors.white70 : Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              Text(
                calendarSelectedDate?.strDayMonth() ??
                    AppLocalizations.of(context)!.choose,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
  
  // Оформление блока с выбором даты
  static BoxDecoration cardDecoration(bool isSelected) {
    return BoxDecoration(
      color: isSelected ? Colors.blue : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isSelected ? Colors.blue : Colors.grey.shade300,
        width: 1,
      ),
      boxShadow: isSelected
          ? null
          : [
        BoxShadow(
          color: Colors.grey.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }
}

// Выделенный виджет для квадратика
class _DateItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: _DateSliderState.cardDecoration(isSelected),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.strWeekday(),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white70 : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              date.strDayMonth(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
