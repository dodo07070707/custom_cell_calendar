import 'package:flutter/material.dart';

/// DataModel of event
///
/// [eventName] and [eventDate] is essential to show in [CellCalendar]
class CalendarEvent {
  CalendarEvent({
    required this.eventName,
    required this.eventDate,
    required this.eventTextStyle,
    this.eventBackgroundColor = const Color(0xFF38498E), // ! 이벤트 고유 색
    this.eventID,
  });

  final String eventName;
  final TextStyle eventTextStyle;
  final DateTime eventDate;
  final String? eventID;
  final Color eventBackgroundColor;
}
