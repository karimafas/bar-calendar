library bar_calendar;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const double dayColumnWidth = 60;
const double headerHeight = 70;

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

Months month(int m) {
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

  DateTime start;
  DateTime end;

  EventBarType eventBarType;

  EventObj(
      {required this.title,
      required this.color,
      required this.start,
      required this.end,
      this.eventBarType = EventBarType.small});
}

enum EventBarType { large, small }

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
  late DateTime minDate;
  late DateTime maxDate;

  @override
  void initState() {
    super.initState();

    List<DateTime> startDates = widget.events.map((e) => e.start).toList();
    startDates = startDates.toList();
    minDate = startDates.isEmpty
        ? DateTime.now().subtract(const Duration(days: 7))
        : startDates.reduce((min, e) => e.isBefore(min) ? e : min);

    List<DateTime> endDates = widget.events.map((e) => e.end).toList();
    endDates = endDates.toList();
    maxDate = endDates.isEmpty
        ? DateTime.now().add(const Duration(days: 7))
        : endDates.reduce((max, e) => e.isAfter(max) ? e : max);
  }

  @override
  Widget build(BuildContext context) {
    int totalDays = daysBetween(minDate, maxDate);
    List<DateTime> days = [];

    for (int i = 0; i < totalDays; i++) {
      days.add(minDate.add(Duration(days: i)));
    }

    return LayoutBuilder(builder: (context, constraints) {
      final double headerWidth = constraints.maxWidth;
      return Container(
        color: widget.backgroundColor,
        child: Stack(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days
                    .asMap()
                    .map((index, d) => MapEntry(
                          index,
                          Row(
                            children: [
                              Container(
                                  width: headerWidth / totalDays - 1,
                                  color: d.weekday == 6 || d.weekday == 7
                                      ? Colors.grey.withOpacity(.3)
                                      : Colors.transparent),
                              Container(
                                  width: 1,
                                  color: index != days.length - 1
                                      ? Colors.grey.withOpacity(.4)
                                      : Colors.transparent)
                            ],
                          ),
                        ))
                    .values
                    .toList()),
            Column(children: [
              Header(daysBetween: days, minDate: minDate, maxDate: maxDate),
              ...widget.events
                  .map((e) => e.eventBarType == EventBarType.large
                      ? EventBarLarge(
                          event: e, minDate: minDate, maxDate: maxDate)
                      : EventBarSmall(
                          event: e, minDate: minDate, maxDate: maxDate))
                  .toList(),
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days
                    .asMap()
                    .map((index, d) => MapEntry(
                          index,
                          Container(
                            padding: const EdgeInsets.only(top: headerHeight),
                            width: headerWidth / totalDays,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 2.5,
                                    color: d.day == DateTime.now().day
                                        ? Colors.blue.withOpacity(.5)
                                        : Colors.transparent),
                              ],
                            ),
                          ),
                        ))
                    .values
                    .toList()),
          ],
        ),
      );
    });
  }
}

enum HeaderType { full, condensed }

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

    return LayoutBuilder(builder: (context, constraints) {
      final double headerWidth = constraints.maxWidth;
      HeaderType headerType = HeaderType.full;
      final List<Months> months = [];

      if (headerWidth / daysBetween.length < dayColumnWidth) {
        headerType = HeaderType.condensed;

        int lastMonth = -1;
        for (final date in daysBetween) {
          if (date.month != lastMonth) {
            months.add(month(date.month));
            lastMonth = date.month;
          }
        }
      }

      return Container(
          margin: const EdgeInsets.only(bottom: 30),
          height: headerHeight,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(.2))
          ]),
          child: headerType == HeaderType.full
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: daysBetween
                      .map((d) => Container(
                            width: headerWidth / daysBetween.length,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    d.day == 1 || d == minDate || d == maxDate
                                        ? monthFormatter.format(d).toUpperCase()
                                        : '',
                                    style: _display5),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(dayFormatter.format(d).substring(0, 1),
                                        style: _display4,
                                        textAlign: TextAlign.start),
                                    Text(dateFormatter.format(d),
                                        style: _display2,
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                              ],
                            ),
                          ))
                      .toList())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: months
                      .map((m) => Container(
                            width: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.name.substring(0, 1).toUpperCase(),
                                    style: _display4),
                              ],
                            ),
                          ))
                      .toList()));
    });
  }
}

class EventBarLarge extends StatelessWidget {
  const EventBarLarge(
      {Key? key,
      required this.event,
      required this.minDate,
      required this.maxDate})
      : super(key: key);

  final EventObj event;
  final DateTime minDate;
  final DateTime maxDate;

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('d MMMM');
    return Row(
      children: [
        Expanded(flex: daysBetween(minDate, event.start), child: Container()),
        Expanded(
          flex: daysBetween(event.start, event.end),
          child: Container(
              height: 100,
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
                    Text(
                        '${formatter.format(event.start)} ${' - ${formatter.format(event.end)}'}',
                        style: _display3)
                  ],
                ),
              )),
        ),
        Expanded(flex: daysBetween(event.end, maxDate), child: Container()),
      ],
    );
  }
}

class EventBarSmall extends StatelessWidget {
  const EventBarSmall(
      {Key? key,
      required this.event,
      required this.minDate,
      required this.maxDate})
      : super(key: key);

  final EventObj event;
  final DateTime minDate;
  final DateTime maxDate;

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('d MMMM');
    return Row(
      children: [
        Expanded(flex: daysBetween(minDate, event.start), child: Container()),
        Expanded(
          flex: daysBetween(event.start, event.end),
          child: Container(
              height: 55,
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
                    Text(
                        '${formatter.format(event.start)} ${' - ${formatter.format(event.end)}'}',
                        style: _display3)
                  ],
                ),
              )),
        ),
        Expanded(flex: daysBetween(event.end, maxDate), child: Container()),
      ],
    );
  }
}
