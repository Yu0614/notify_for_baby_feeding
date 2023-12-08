import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart'; // https://pub.dev/packages/flutter_week_view
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:notify_for_baby_feeding/models/feed/feed.dart';
import 'package:notify_for_baby_feeding/models/result/result.dart';

import '../parts/show_modal_bottom_sheet_for_register.dart';
import '../../../../view_models/day_view/feed_view_model.dart';
import '../../../../repository/feed_repository.dart';

final logger = Logger();

/// A day view that displays dynamically added events.
class DynamicDayView extends StatefulWidget {
  const DynamicDayView({super.key});

  @override
  State<StatefulWidget> createState() => DynamicDayViewState();
}

/// The dynamic day view state.
class DynamicDayViewState extends State<DynamicDayView> {
  List<FlutterWeekViewEvent> events = [];
  final feedViewModel = FeedViewModel(FeedRepository());
  late Result<List<FeedModel>> result;

  @override
  void initState() {
    super.initState();
    DateTime feedAt;
    Future(
      () async {
        result = await feedViewModel.loadByDate(DateTime.now());
        for (final data in result.dataOrThrow) {
          feedAt = data.feedAt as DateTime;
          setState(() {
            events.add(FlutterWeekViewEvent(
              title: "ミルク ${events.length + 1} 回目 ${data.amount} ml",
              start: DateTime.parse(feedAt.toIso8601String()),
              end: feedAt.add(const Duration(minutes: 45)),
              description: "",
              padding: const EdgeInsets.all(10),
            ));
          });
        }
      },
    );
  }

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
              showModalBottomSheetForRegister(context, formattedDate,
                  roundTimeToFitGrid(now), events, feedViewModel);
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
              context, formattedDate, dateTime, events, feedViewModel);
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
