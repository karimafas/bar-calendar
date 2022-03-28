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
        backgroundColor: const Color(0xFFE2F1FF),
        headerDecoration:
            CalendarHeaderDecoration(backgroundColor: const Color(0xFFBADFFF)),
        events: [
          CalendarEvent(
              title: 'Project 1',
              eventBarSize: EventBarSize.large,
              decoration: EventBarDecoration(progressionBarColor: Colors.red),
              start: DateTime.now().subtract(const Duration(days: 5)),
              end: DateTime.now().add(const Duration(days: 6))),
          CalendarEvent(
              title: 'Project 2',
              eventBarSize: EventBarSize.large),
        ],
      ),
    ));
  }
}
