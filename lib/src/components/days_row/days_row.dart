import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'event_labels.dart';
import 'measure_size.dart';

final cellHeightProvider = StateProvider<double?>((ref) => null);

/// Show the row of [_DayCell] cells with events
class DaysRow extends StatelessWidget {
  const DaysRow({
    Key? key,
    required this.visiblePageDate,
    required this.dates,
    required this.dateTextStyle,
    required this.onCellTapped,
    required this.todayMarkColor,
    required this.todayTextColor,
    required this.events,
  }) : super(key: key);

  final List<DateTime> dates;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;
  final void Function(DateTime)? onCellTapped;
  final Color todayMarkColor;
  final Color todayTextColor;
  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: dates.map((date) {
          return _DayCell(
            date: date,
            visiblePageDate: visiblePageDate,
            dateTextStyle: dateTextStyle,
            onCellTapped: onCellTapped,
            todayMarkColor: todayMarkColor,
            todayTextColor: todayTextColor,
            events: events,
          );
        }).toList(),
      ),
    );
  }
}

/// Cell of calendar.
///
/// Its height is circulated by [MeasureSize] and notified by [CellHeightController]
class _DayCell extends HookConsumerWidget {
  _DayCell({
    required this.date,
    required this.visiblePageDate,
    required this.dateTextStyle,
    required this.onCellTapped,
    required this.todayMarkColor,
    required this.todayTextColor,
    required this.events,
  });

  final DateTime date;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;
  final void Function(DateTime)? onCellTapped;
  final Color todayMarkColor;
  final Color todayTextColor;
  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onCellTapped?.call(date);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
            ),
          ),
          child: MeasureSize(
            onChange: (size) {
              final sizeState = ref.read(cellHeightProvider);
              if (sizeState != null || size == null) {
                return;
              }
              final notifier = ref.read(cellHeightProvider.notifier);
              notifier.state = size.height;
            },
            child: Column(
              children: [
                isToday
                    ? _TodayLabel(
                        date: date,
                        dateTextStyle: dateTextStyle,
                        todayMarkColor: todayMarkColor,
                        todayTextColor: todayTextColor,
                      )
                    : _DayLabel(
                        date: date,
                        visiblePageDate: visiblePageDate,
                        dateTextStyle: dateTextStyle,
                      ),
                EventLabels(
                  date: date,
                  events: events,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayLabel extends StatelessWidget {
  const _TodayLabel({
    Key? key,
    required this.date,
    required this.dateTextStyle,
    required this.todayMarkColor,
    required this.todayTextColor,
  }) : super(key: key);

  final DateTime date;
  final TextStyle? dateTextStyle;
  final Color todayMarkColor;
  final Color todayTextColor;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final caption = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontWeight: FontWeight.w500);
    final textStyle = caption.merge(dateTextStyle);
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 844 * 2.5),
      height: screenHeight / 844 * 27,
      width: screenHeight / 844 * 27,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: todayMarkColor,
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            color: todayTextColor,
          ),
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel({
    Key? key,
    required this.date,
    required this.visiblePageDate,
    required this.dateTextStyle,
  }) : super(key: key);

  final DateTime date;
  final DateTime visiblePageDate;
  final TextStyle? dateTextStyle;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final isCurrentMonth = visiblePageDate.month == date.month;
    final caption = Theme.of(context).textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface);
    final textStyle = caption.merge(dateTextStyle);
    return Container(
      margin: EdgeInsets.only(
        top: screenHeight / 844 * 10,
        bottom: screenHeight / 844 * 6, //! 날짜 기준 위아래 Padding
      ),
      height: screenHeight / 844 * 13,
      child: Text(
        date.day.toString(),
        textAlign: TextAlign.center,
        style: textStyle.copyWith(
          color: date.weekday == DateTime.sunday
              ? Color(0xFFD20000)
              : date.weekday == DateTime.saturday
                  ? Color(0xFF5100FD)
                  : isCurrentMonth
                      ? textStyle.color
                      : textStyle.color!.withOpacity(0.4),
        ),
      ),
    );
  }
}
