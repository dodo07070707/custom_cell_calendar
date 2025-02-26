import 'package:cell_calendar/src/components/days_row/days_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../calendar_event.dart';

/// Numbers to return accurate events in the cell.
const dayLabelContentHeight = 16;
const dayLabelVerticalMargin = 8;
const _dayLabelHeight = dayLabelContentHeight + (dayLabelVerticalMargin * 2);

const _eventLabelContentHeight = 13;
const _eventLabelBottomMargin = 3;
const _eventLabelHeight = _eventLabelContentHeight + _eventLabelBottomMargin;

/// Get events to be shown from [CalendarStateController]
///
/// Shows accurate number of [_EventLabel] by the height of the parent cell
class EventLabels extends HookConsumerWidget {
  EventLabels({
    required this.date,
    required this.events,
  });

  final DateTime date;
  final List<CalendarEvent> events;

  List<CalendarEvent> _eventsOnTheDay(
      DateTime date, List<CalendarEvent> events) {
    final res = events
        .where((event) =>
            event.eventDate.year == date.year &&
            event.eventDate.month == date.month &&
            event.eventDate.day == date.day)
        .toList();
    return res;
  }

  bool _hasEnoughSpace(double cellHeight, int eventsLength) {
    final eventsTotalHeight = _eventLabelHeight * eventsLength;
    final spaceForEvents = cellHeight - _dayLabelHeight;
    return spaceForEvents > eventsTotalHeight;
  }

  int _maxIndex(double cellHeight, int eventsLength) {
    final spaceForEvents = cellHeight - _dayLabelHeight;
    const indexing = 1;
    const indexForPlot = 1;
    return spaceForEvents ~/ _eventLabelHeight - (indexing + indexForPlot);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cellHeight = ref.watch(cellHeightProvider);
    if (cellHeight == null) {
      return const SizedBox.shrink();
    }
    final eventsOnTheDay = _eventsOnTheDay(date, events);
    final hasEnoughSpace = _hasEnoughSpace(cellHeight, eventsOnTheDay.length);
    final maxIndex = _maxIndex(cellHeight, eventsOnTheDay.length);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: eventsOnTheDay.length,
      itemBuilder: (context, index) {
        if (index == 0 || index == 1) {
          return _EventLabel(eventsOnTheDay[index], index);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

/// label to show [CalendarEvent]
class _EventLabel extends StatelessWidget {
  _EventLabel(this.event, this.index);

  final CalendarEvent event;
  final int index;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight / 844 * 18,
      margin: EdgeInsets.only(
          top: (index == 0) ? screenHeight / 844 * 2 : screenHeight / 844 * 5,
          left: screenWidth / 390 * 2.5,
          right: screenWidth / 390 * 2.5),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: event.eventBackgroundColor,
      ),
      child: Center(
        child: Text(
          event.eventName,
          style: event.eventTextStyle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
