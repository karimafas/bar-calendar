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
        backgroundColor: Colors.grey.withOpacity(.4),
        events: [
          CalendarEvent(
              title: 'First Event',
              color: Colors.white,
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 8))),
          CalendarEvent(
              title: 'Second Event',
              color: Colors.white,
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 8))),
          CalendarEvent(
              title: 'Third Event',
              eventBarSize: EventBarSize.large,
              color: Colors.red,
              decoration: EventBarDecoration(
                main: TextStyle(color: Colors.white)
              ),
              start: DateTime.now().subtract(const Duration(days: 3)),
              end: DateTime.now().add(const Duration(days: 10)))
        ],
      ),
    ));
  }
}
