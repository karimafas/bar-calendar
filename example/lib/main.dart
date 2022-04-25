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
      height: 600,
      width: 1000,
      child: BarCalendar(
        backgroundColor: Colors.white,
        headerDecoration:
            CalendarHeaderDecoration(backgroundColor: Colors.white),
        events: [
          CalendarEvent(
              title: 'Introducing: Boxing.',
              eventBarSize: EventBarSize.large,
              start: DateTime(2022, 3, 4),
              end: DateTime(2022, 3, 23)),
          CalendarEvent(
              title: 'hitlist', end: DateTime(2022, 5, 31), start: null),
          CalendarEvent(title: 'update', start: null, end: null),
          CalendarEvent(
              title: 'Curated Content For You',
              start: DateTime(2022, 3, 4),
              end: DateTime(2022, 3, 31)),
          CalendarEvent(
              title: 'Parkrun Launch',
              end: DateTime(2059, 1, 31),
              start: DateTime(2022, 3, 4)),
        ],
      ),
    ));
  }
}
