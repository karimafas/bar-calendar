import 'package:bar_calendar/bar_calendar.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
          child: SizedBox(
        width: 1000,
        child: BarCalendar(
          backgroundColor: Colors.grey.withOpacity(.4),
          events: [
            EventObj(
                title: 'First Event',
                color: Colors.white,
                start: DateTime.now(),
                end: DateTime.now().add(const Duration(days: 8))),
            EventObj(
                title: 'First Event',
                color: Colors.white,
                start: DateTime.now(),
                end: DateTime.now().add(const Duration(days: 8))),
            EventObj(
                title: 'Second Event',
                color: Colors.white,
                eventBarType: EventBarType.large,
                start: DateTime.now().subtract(const Duration(days: 3)),
                end: DateTime.now().add(const Duration(days: 10)))
          ],
        ),
      )),
    ),
  ));
}
