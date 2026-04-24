import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/ui_kit/ui_kit.dart';

class DateSlider extends StatefulWidget {
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? initialDate;

  const DateSlider({
    Key? key,
    this.onDateSelected,
    this.initialDate,
  }) : super(key: key);

  @override
  State<DateSlider> createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  static const double _itemMinHeight = 55;

  static const double _horizontalPadding = 12;
  static const double _itemSpacing = 6;

  static const double _minItemWidth = 50;
  static const double _maxItemWidth = 110;

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

    for (int i = -2; i <= 1; i++) {
      _dates.add(DateTime(now.year, now.month, now.day + i));
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

  void _scrollToSelectedDate() {
    if (!_scrollController.hasClients) return;

    final index = _dates.indexWhere((date) => _isSameDay(date, _selectedDate));
    if (index == -1) return;

    final approxItemExtent = _minItemWidth + _itemSpacing;
    final targetOffset = index * approxItemExtent;

    _scrollController.animateTo(
      targetOffset.clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _calculateItemWidth(double maxWidth, int totalItems) {
    final totalHorizontalPadding = _horizontalPadding * 2;
    final totalSpacing = (totalItems - 1) * _itemSpacing;
    final available = maxWidth - totalHorizontalPadding - totalSpacing;

    final fittedWidth = available / totalItems;
    return fittedWidth.clamp(_minItemWidth, _maxItemWidth);
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _dates.length + 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = _calculateItemWidth(constraints.maxWidth, totalItems);

        final children = List<Widget>.generate(totalItems, (index) {
          final isLast = index == _dates.length;

          return Padding(
            padding: EdgeInsets.only(
              right: index == totalItems - 1 ? 0 : _itemSpacing,
            ),
            child: SizedBox(
              width: isLast ? null : itemWidth,
              child: isLast
                  ? _buildCalendarButton(context, itemWidth)
                  : _buildDateItem(index, itemWidth),
            ),
          );
        });

        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateItem(int index, double width) {
    final date = _dates[index];
    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isToday(date);

    return _DateItem(
      date: date,
      isSelected: isSelected,
      isToday: isToday,
      width: width,
      minHeight: _itemMinHeight,
      onTap: () {
        setState(() {
          _selectedDate = date;
          calendarSelectedDate = null;
        });
        widget.onDateSelected?.call(date);
      },
    );
  }

  Widget _buildCalendarButton(BuildContext context, double width) {
    final isSelected = calendarSelectedDate != null &&
        _isSameDay(calendarSelectedDate!, _selectedDate);

    return GestureDetector(
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
        //width: width,
        constraints: BoxConstraints(minHeight: _itemMinHeight, minWidth: width),
        decoration: cardDecoration(isSelected),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.calendar_1,
              size: 18,
              color: isSelected ? Colors.white70 : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              calendarSelectedDate?.strDayMonth() ?? AppLocalizations.of(context)!.choose,
              maxLines: 1,
              //overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width < 75 ? 11 : 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static BoxDecoration cardDecoration(bool isSelected) {
    return BoxDecoration(
      color: isSelected ? AppT.c.primary : Colors.white,
      borderRadius: BorderRadius.circular(12),
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

class _DateItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final double width;
  final double minHeight;
  final VoidCallback onTap;

  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.width,
    required this.minHeight,
    required this.onTap,
  });

  bool _fitsText({required BuildContext context, required String text, required TextStyle style, required double maxWidth}) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: Directionality.of(context),
      locale: Localizations.localeOf(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(minWidth: 0, maxWidth: double.infinity);

    // Небольшой запас, чтобы не получать визуальное обрезание
    const safetyPadding = 4.0;

    return textPainter.width <= (maxWidth - safetyPadding);
  }

  @override
  Widget build(BuildContext context) {
    final weekdayFontSize = width < 72 ? 10.0 : 12.0;
    final dateFontSize = width < 75 ? 13.0 : 16.0;

    final weekdayStyle = TextStyle(
      fontSize: weekdayFontSize,
      color: isSelected ? Colors.white70 : Colors.grey.shade600,
      fontWeight: FontWeight.w500,
    );

    final dateStyle = TextStyle(
      fontSize: dateFontSize,
      fontWeight: FontWeight.bold,
      color: isSelected ? Colors.white : Colors.black87,
    );

    final fullDateText = date.strDayMonth();
    final shortDateText = '${date.day}';

    // padding horizontal = 4 + 4
    final availableTextWidth = width - 8;

    final dateText = _fitsText(
      context: context,
      text: fullDateText,
      style: dateStyle,
      maxWidth: availableTextWidth,
    )
        ? fullDateText
        : shortDateText;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        constraints: BoxConstraints(minHeight: minHeight),
        decoration: _DateSliderState.cardDecoration(isSelected),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.strWeekday(),
              maxLines: 1,
              style: weekdayStyle,
            ),
            const SizedBox(height: 4),
            Text(
              dateText,
              maxLines: 1,
              style: dateStyle,
            ),
          ],
        ),
      ),
    );
  }
}