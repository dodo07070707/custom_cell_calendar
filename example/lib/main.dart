import 'package:cell_calendar/cell_calendar.dart';
import 'package:example/sample_event.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'cell_calendar example'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final events = sampleEvents();
    final cellCalendarPageController = CellCalendarPageController();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: CellCalendar(
        cellCalendarPageController: cellCalendarPageController,
        events: events,
        daysOfTheWeekBuilder: (dayIndex) {
          final labels = ["S", "M", "T", "W", "T", "F", "S"];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              labels[dayIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        onCellTapped: (date) {
          final eventsOnTheDate = events.where((event) {
            final eventDate = event.eventDate;
            return eventDate.year == date.year &&
                eventDate.month == date.month &&
                eventDate.day == date.day;
          }).toList();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("${date.month.monthName} ${date.day}"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: eventsOnTheDate
                          .map(
                            (event) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 12),
                              color: event.eventBackgroundColor,
                              child: Text(
                                event.eventName,
                                style: event.eventTextStyle,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ));
        },
        onPageChanged: (firstDate, lastDate) {
          /// Called when the page was changed
          /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
        },
      ),
    );
  }
}
