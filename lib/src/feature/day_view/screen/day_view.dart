import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart'; // https://pub.dev/packages/flutter_week_view
import 'package:intl/intl.dart';
import '../parts/show_modal_bottom_sheet_for_register.dart';

/// A day view that displays dynamically added events.
class DynamicDayView extends StatefulWidget {
  const DynamicDayView({super.key});

  @override
  State<StatefulWidget> createState() => DynamicDayViewState();
}

/// The dynamic day view state.
class DynamicDayViewState extends State<DynamicDayView> {
  /// The added events.
  List<FlutterWeekViewEvent> events = [];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy年MM月dd日').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
        actions: [
          IconButton(
            onPressed: () {
              // _settingModalBottomSheet(context, true, formattedDate);
              // setState(() {
              //   DateTime start = DateTime(now.year, now.month, now.day,
              //       Random().nextInt(24), Random().nextInt(60));
              //   events.add(FlutterWeekViewEvent(
              //     title: 'Evento ${events.length + 1}',
              //     start: start,
              //     end: start.add(const Duration(hours: 1)),
              //     description: 'A description.',
              //   ));
              // });
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: DayView(
        events: events,
        initialTime: HourMinute.fromDateTime(
            dateTime: now.copyWith(
                minute: now.minute - 30)), // 常に現在時から描画してしまうので30分ずらす
        date: now,
        dayBarStyle: DayBarStyle.fromDate(
            date: now,
            dateFormatter: (int year, int month, int day) => '生後xx日'),
        onBackgroundTappedDown: (DateTime dateTime) {
          dateTime = roundTimeToFitGrid(dateTime);
          showModalBottomSheetForRegister(
              context, formattedDate, dateTime, events);
        },
        // dragAndDropOptions: DragAndDropOptions(
        //   onEventDragged: (FlutterWeekViewEvent event, DateTime newStartTime) {
        //     DateTime roundedTime = roundTimeToFitGrid(now,
        //         gridGranularity: const Duration(minutes: 15));
        //     event.shiftEventTo(roundedTime);
        //     setState(() {
        //       /* State set is the shifted event's time. */
        //     });
        //   },
        // ),
        // resizeEventOptions: ResizeEventOptions(
        //   onEventResized: (FlutterWeekViewEvent event, DateTime newEndTime) {
        //     event.end = newEndTime;
        //     setState(() {
        //       /* State set is the resized event's time. */
        //     });
        //   },
        // ),
      ),
    );
  }
}
