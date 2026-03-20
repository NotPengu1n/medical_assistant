import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';

class DateSlider extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final DateTime? initialDate;
  final double itemWidth;
  final double itemHeight;

  const DateSlider({
    Key? key,
    this.onDateSelected,
    this.initialDate,
    this.itemWidth = 70,
    this.itemHeight = 90,
  }) : super(key: key);

  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  late DateTime _selectedDate;
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

    for (int i = -4; i <= 4; i++) {
      _dates.add(DateTime(now.year, now.month, now.day + i));
    }
  }

  void _scrollToSelectedDate() {
    final index = _dates.indexWhere(
            (date) => _isSameDay(date, _selectedDate)
    );
    if (index != -1) {
      _scrollController.animateTo(
        (index * (widget.itemWidth + 8)).clamp(0, _scrollController.position.maxScrollExtent),
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

  String _getDayOfWeek(DateTime date) {
    final weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    return weekdays[date.weekday - 1];
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  String _getSlotsCount(DateTime date) {
    return '5 / 8';
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
        itemCount: _dates.length,
        itemBuilder: (context, index) {
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
                });
                //_scrollToSelectedDate();
                widget.onDateSelected?.call(date);
              },
              getSlotsCount: _getSlotsCount,
            ),
          );
        },
      ),
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
  final String Function(DateTime) getSlotsCount;

  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.width,
    required this.height,
    required this.onTap,
    required this.getSlotsCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1,
          ),
          // Убираем тень, если не нужна
          boxShadow: isSelected ? null : [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
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
            if (isToday)
              Container(
                margin: EdgeInsets.only(top: 2),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'сегодня',
                  style: TextStyle(
                    fontSize: 8,
                    color: isSelected ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (!isToday) SizedBox(height: 4),
            Text(
              getSlotsCount(date),
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}