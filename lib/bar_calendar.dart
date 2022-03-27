library bar_calendar;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

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
TextStyle _display6 = const TextStyle(
    color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);

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

int minutesBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
  to = DateTime(to.year, to.month, to.day, to.hour, to.month);

  return (to.difference(from).inMinutes).round();
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

class Month {
  Months month;
  int year;

  Month(this.month, this.year);
}

class CalendarEvent {
  String title;
  Color color;

  DateTime start;
  DateTime end;

  EventBarType eventBarType;

  CalendarEvent(
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

  final List<CalendarEvent> events;
  final Color backgroundColor;

  @override
  State<BarCalendar> createState() => _BarCalendarState();
}

class _BarCalendarState extends State<BarCalendar> {
  _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 100),
        initialDateRange: DateTimeRange(
          end: maxDate,
          start: minDate,
        ),
        builder: (context, child) {
          return Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400.0,
                ),
                child: child,
              )
            ],
          );
        });

    if (picked != null) {
      setState(() {
        minDate = picked.start;
        maxDate = picked.end;
      });
    }
  }

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

    return LayoutBuilder(builder: (layoutContext, constraints) {
      final double headerWidth = constraints.maxWidth;
      return Container(
        color: widget.backgroundColor,
        child: Stack(
          children: [
            DaySeparators(
                days: days, headerWidth: headerWidth, totalDays: totalDays),
            ListView(
                padding: const EdgeInsets.only(top: headerHeight + 15),
                children: [
                  ...widget.events
                      .map((e) => e.eventBarType == EventBarType.large
                          ? EventBarLarge(
                              event: e, minDate: minDate, maxDate: maxDate)
                          : EventBarSmall(
                              event: e, minDate: minDate, maxDate: maxDate))
                      .toList(),
                ]),
            Header(daysBetween: days, minDate: minDate, maxDate: maxDate),
            CurrentDayIndicator(
                days: days, headerWidth: headerWidth, totalDays: totalDays),
            Positioned(
              bottom: 30,
              right: 30,
              child: DateRangePicker(
                  minDate: minDate, maxDate: maxDate, onTap: _pickDateRange),
            )
          ],
        ),
      );
    });
  }
}

class DateRangePicker extends StatelessWidget {
  const DateRangePicker({
    Key? key,
    required this.minDate,
    required this.maxDate,
    required this.onTap,
  }) : super(key: key);

  final DateTime minDate;
  final DateTime maxDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('d MMMM');
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(formatter.format(minDate), style: _display6),
            const Icon(Icons.arrow_right),
            Text(formatter.format(maxDate), style: _display6),
          ],
        ),
      ),
    );
  }
}

class CurrentDayIndicator extends StatelessWidget {
  const CurrentDayIndicator({
    Key? key,
    required this.days,
    required this.headerWidth,
    required this.totalDays,
  }) : super(key: key);

  final List<DateTime> days;
  final double headerWidth;
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days
            .asMap()
            .map((index, d) => MapEntry(
                  index,
                  Container(
                    padding: const EdgeInsets.only(top: headerHeight),
                    width: headerWidth / totalDays,
                    child: Row(
                      children: [
                        Expanded(
                            flex: minutesBetween(
                                DateTime(now.year, now.month, now.day, 0, 0),
                                DateTime.now()),
                            child: Container()),
                        Row(
                          children: [
                            Container(
                                width: 2.5,
                                color: d.day == DateTime.now().day
                                    ? Colors.blue.withOpacity(.5)
                                    : Colors.transparent),
                          ],
                        ),
                        Expanded(
                            flex: minutesBetween(
                                DateTime.now(),
                                DateTime(
                                    now.year, now.month, now.day + 1, 0, 0)),
                            child: Container()),
                      ],
                    ),
                  ),
                ))
            .values
            .toList());
  }
}

class DaySeparators extends StatelessWidget {
  const DaySeparators({
    Key? key,
    required this.days,
    required this.headerWidth,
    required this.totalDays,
  }) : super(key: key);

  final List<DateTime> days;
  final double headerWidth;
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            .toList());
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
      final List<Month> months = [];

      if (headerWidth / daysBetween.length < dayColumnWidth) {
        headerType = HeaderType.condensed;

        int lastMonth = -1;
        for (final date in daysBetween) {
          if (date.month != lastMonth) {
            months.add(Month(month(date.month), date.year));
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
                      .map((d) => Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: headerWidth / daysBetween.length - 1,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        d.day == 1 ||
                                                d == minDate ||
                                                d == maxDate
                                            ? monthFormatter
                                                .format(d)
                                                .toUpperCase()
                                            : '',
                                        style: _display5),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            dayFormatter
                                                .format(d)
                                                .substring(0, 1),
                                            style: _display4,
                                            textAlign: TextAlign.start),
                                        Text(dateFormatter.format(d),
                                            style: _display2,
                                            textAlign: TextAlign.start),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: 1,
                                  height: 10,
                                  color: Colors.grey.withOpacity(.2))
                            ],
                          ))
                      .toList())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: months
                      .map((m) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(
                                  '${m.month.name.capitalize()} ${m.year}',
                                  style: _display4),
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

  final CalendarEvent event;
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
                    Flexible(
                      child: SizedBox(
                        child: Text(
                          event.title,
                          style: _display1,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.flag_rounded,
                            color: Colors.grey, size: 10),
                        const SizedBox(width: 5),
                        Flexible(
                          child: SizedBox(
                            child: Text(
                              '${formatter.format(event.start)} ${' - ${formatter.format(event.end)}'}',
                              style: _display3,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ),
                      ],
                    )
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

  final CalendarEvent event;
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
                    Flexible(
                      child: SizedBox(
                        child: Text(
                          event.title,
                          style: _display2,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.flag_rounded, color: Colors.grey, size: 8),
                    const SizedBox(width: 5),
                    Flexible(
                      child: SizedBox(
                        child: Text(
                            '${formatter.format(event.start)} ${' - ${formatter.format(event.end)}'}',
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: _display3),
                      ),
                    )
                  ],
                ),
              )),
        ),
        Expanded(flex: daysBetween(event.end, maxDate), child: Container()),
      ],
    );
  }
}
