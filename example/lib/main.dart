import 'package:bar_calendar/bar_calendar.dart';
import 'package:flutter/material.dart';

main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: HomePage(),
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: BarCalendar(
        backgroundColor: Color(0xFFE2F1FF),
        headerDecoration:
            CalendarHeaderDecoration(backgroundColor: Color(0xFFBADFFF)),
        events: [
          CalendarEvent(
              title: 'Project 1',
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 8))),
          CalendarEvent(
              title: 'Project 2',
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 8))),
          CalendarEvent(
              title: 'Project 3',
              eventBarSize: EventBarSize.large,
              start: DateTime.now().subtract(const Duration(days: 3)),
              end: DateTime.now().add(const Duration(days: 10))),
          CalendarEvent(
              title: 'Project 4',
              eventBarSize: EventBarSize.large,
              start: DateTime.now().subtract(const Duration(days: 5)),
              end: DateTime.now().add(const Duration(days: 4)))
        ],
      ),
    ));
  }
}
