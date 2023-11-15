import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

/// The demo week view widget.
class DemoWeekView extends StatelessWidget {
  const DemoWeekView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return WeekView(
      initialTime: const HourMinute(hour: 7).atDate(DateTime.now()),
      dates: [
        date.subtract(const Duration(days: 1)),
        date,
        date.add(const Duration(days: 1))
      ],
      events: [
        FlutterWeekViewEvent(
          title: 'An event 1',
          description: 'A description 1',
          start: date.subtract(const Duration(hours: 1)),
          end: date.add(const Duration(hours: 18, minutes: 30)),
        ),
        FlutterWeekViewEvent(
          title: 'An event 2',
          description: 'A description 2',
          start: date.add(const Duration(hours: 19)),
          end: date.add(const Duration(hours: 22)),
        ),
        FlutterWeekViewEvent(
          title: 'An event 3',
          description: 'A description 3',
          start: date.add(const Duration(hours: 23, minutes: 30)),
          end: date.add(const Duration(hours: 25, minutes: 30)),
        ),
        FlutterWeekViewEvent(
          title: 'An event 4',
          description: 'A description 4',
          start: date.add(const Duration(hours: 20)),
          end: date.add(const Duration(hours: 21)),
        ),
        FlutterWeekViewEvent(
          title: 'An event 5',
          description: 'A description 5',
          start: date.add(const Duration(hours: 20)),
          end: date.add(const Duration(hours: 21)),
        ),
      ],
    );
  }
}
