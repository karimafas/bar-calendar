<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

This package allows the creation of event-based project calendars.

## Installing:
In your pubspec.yaml
```yaml
dependencies:
  bar_calendar: ^0.0.2
```
```dart
import 'package:bar_calendar/bar_calendar.dart';
```

<br>
<br>

## Basic Usage:
```dart
    BarCalendar(
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
              end: DateTime.now().add(const Duration(days: 8)))
        ],
      )
```

<br>
<br>