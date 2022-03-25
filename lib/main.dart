import 'package:bar_calendar/bar_calendar.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    builder: (context, widget) => Scaffold(
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
                end: DateTime.now().add(const Duration(days: 100)))
          ],
        ),
      )),
    ),
  ));
}
