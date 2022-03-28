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

<img src="https://raw.githubusercontent.com/karimafas/bar-calendar/master/bar-calendar-snap.png" width="550"> 
<img src="https://raw.githubusercontent.com/karimafas/bar-calendar/master/bar-calendar-snap-blue.png" width="550">

## Installing:
In your pubspec.yaml
```yaml
dependencies:
  bar_calendar: ^0.0.5
```
```dart
import 'package:bar_calendar/bar_calendar.dart';
```

## Basic Usage:
```dart
    BarCalendar(
        backgroundColor: Colors.grey.withOpacity(.4),
        events: [
          CalendarEvent(
              title: 'First Event',
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 8))),
          CalendarEvent(
              title: 'Second Event',
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 8))),
          CalendarEvent(
              title: 'Third Event',
              eventBarSize: EventBarSize.large,
              start: DateTime.now().subtract(const Duration(days: 3)),
              end: DateTime.now().add(const Duration(days: 10)))
        ],
      )
```

## BarCalendar
CalendarEvent objects must be wrapped in a BarCalendar.

|  Properties  |   Description   |
|--------------|-----------------|
| `Color backgroundColor` | The background color of the calendar. |
| `CalendarHeaderDecoration headerDecoration` | An object that allows full header customisation. |
| `List<CalendarEvent> events` | A list of events to display. |

### CalendarHeaderDecoration
An object that allows full header customisation.

|  Properties  |   Description   |
|--------------|-----------------|
| `Color? backgroundColor` | The background color of the header (default: Colors.white). |
| `TextStyle? day` | TextStyle applied to the day of month (number). |
| `TextStyle? day` | TextStyle applied to the day of (letter). |
| `TextStyle? day` | TextStyle applied to the month of (when calendar is in condensed view). |

## CalendarEvent
The CalendarEvent object includes information on the events displayed in the calendar.

|  Properties  |   Description   |
|--------------|-----------------|
| `String title` | The event title, displayed on the calendar. |
| `Color? color` | The background color for the event bar (default: Colors.white). |
| `DateTime? start` | Event start date - if set to null, it is assumed the event has an indefinite start date in the past. |
| `DateTime? end` | Event end date - if set to null, it is assumed the event has an indefinite end date in the future. |
| `EventBarDecoration? decoration` | An object that allows further customisation of the event bar. |
| `EventBarSize eventBarSize` | Defines whether the event should be shown in a large or small bar. |
| `List<CalendarEvent> events` | A list of events to display. |

### EventBarDecoration
An object that allows further customisation of an event bar.

|  Properties  |   Description   |
|--------------|-----------------|
| `TextStyle? main` | TextStyle for the event tytle. |
| `TextStyle? dates` | TextStyle for the event subtitle. |
| `Icon? icon` | An icon to show before the event subtitle (default: Icons.flag). |
| `Color? progressionBarColor` | Color of the event progression bar. |

