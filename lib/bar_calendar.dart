library bar_calendar;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TextStyle _display1 = const TextStyle(
    color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
TextStyle _display2 = const TextStyle(
    color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle _display3 = const TextStyle(
    color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal);
TextStyle _display4 = const TextStyle(
    color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold);
TextStyle _display5 = const TextStyle(
    color: Colors.grey, fontSize: 10, fontWeight: FontWeight.normal);

enum EventType { start, end, startEnd, infinite }

enum Months {
  infinity,
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

Months? month(int m) {
  switch (m) {
    case 1:
      return Months.january;
    case 2:
      return Months.february;
    case 3:
      return Months.march;
    case 4:
      return Months.april;
    case 5:
      return Months.may;
    case 6:
      return Months.june;
    case 7:
      return Months.july;
    case 8:
      return Months.august;
    case 9:
      return Months.september;
    case 10:
      return Months.october;
    case 11:
      return Months.november;
    case 12:
      return Months.december;
    default:
      return Months.infinity;
  }
}

class EventObj {
  String title;
  Color color;

  DateTime? start;
  DateTime? end;

  EventObj({required this.title, required this.color, this.start, this.end});
}

class BarCalendar extends StatefulWidget {
  const BarCalendar(
      {Key? key, required this.events, this.backgroundColor = Colors.white})
      : super(key: key);

  final List<EventObj> events;
  final Color backgroundColor;

  @override
  State<BarCalendar> createState() => _BarCalendarState();
}

class _BarCalendarState extends State<BarCalendar> {
  late DateTime? minDate;
  late DateTime? maxDate;

  @override
  void initState() {
    super.initState();

    List<DateTime?> startDates = widget.events.map((e) => e.start).toList();
    startDates = startDates.where((e) => e != null).toList();
    minDate = startDates.isEmpty
        ? DateTime.now().subtract(const Duration(days: 7))
        : startDates.reduce((min, e) => e!.isBefore(min!) ? e : min);

    List<DateTime?> endDates = widget.events.map((e) => e.end).toList();
    endDates = endDates.where((e) => e != null).toList();
    maxDate = endDates.isEmpty
        ? DateTime.now().add(const Duration(days: 7))
        : endDates.reduce((max, e) => e!.isAfter(max!) ? e : max);
  }

  @override
  Widget build(BuildContext context) {
    int totalDays =
        daysBetween(minDate ?? DateTime.now(), maxDate ?? DateTime.now());
    List<DateTime> days = [];

    for (int i = 0; i < totalDays; i++) {
      days.add(minDate!.add(Duration(days: i)));
    }

    return Container(
      color: widget.backgroundColor,
      child: Column(children: [
        Header(daysBetween: days, minDate: minDate!, maxDate: maxDate!),
        ...widget.events.map((e) => EventBarLarge(event: e)).toList(),
        ...widget.events.map((e) => EventBarSmall(event: e)).toList()
      ]),
    );
  }
}

class Header extends StatelessWidget {
  const Header(
      {Key? key,
      required this.daysBetween,
      required this.minDate,
      required this.maxDate})
      : super(key: key);

  final List<DateTime> daysBetween;
  final DateTime minDate;
  final DateTime maxDate;

  @override
  Widget build(BuildContext context) {
    DateFormat dayFormatter = DateFormat('E');
    DateFormat dateFormatter = DateFormat('dd');
    DateFormat monthFormatter = DateFormat('MMMM');
    return Container(
        margin: const EdgeInsets.only(bottom: 30),
        height: 70,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(.2))
        ]),
        child: Row(
            children: daysBetween
                .map((d) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              d.day == 1 || d == minDate || d == maxDate
                                  ? monthFormatter.format(d).toUpperCase()
                                  : '',
                              style: _display5),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(dayFormatter.format(d).substring(0, 1),
                                  style: _display4),
                              Text(dateFormatter.format(d), style: _display2),
                            ],
                          ),
                        ],
                      ),
                    ))
                .toList()));
  }
}

class EventBarLarge extends StatelessWidget {
  const EventBarLarge({Key? key, required this.event}) : super(key: key);

  final EventObj event;

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('d MMMM');
    return Container(
        height: 100,
        width: 500,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  color: Colors.black.withOpacity(.05))
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(event.title, style: _display1),
              const SizedBox(height: 3),
              if (event.start != null || event.end != null)
                Text(
                    '${event.start == null ? '' : formatter.format(event.start!)} ${event.end == null ? '' : ' - ${formatter.format(event.end!)}'}',
                    style: _display3)
            ],
          ),
        ));
  }
}

class EventBarSmall extends StatelessWidget {
  const EventBarSmall({Key? key, required this.event}) : super(key: key);

  final EventObj event;

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('d MMMM');
    return Container(
        height: 55,
        width: 500,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  color: Colors.black.withOpacity(.05))
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(event.title, style: _display2),
              const SizedBox(width: 10),
              Container(
                  height: 4,
                  width: 4,
                  decoration: const BoxDecoration(
                      color: Colors.grey, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              if (event.start != null || event.end != null)
                Text(
                    '${event.start == null ? '' : formatter.format(event.start!)} ${event.end == null ? '' : ' - ${formatter.format(event.end!)}'}',
                    style: _display3)
            ],
          ),
        ));
  }
}
