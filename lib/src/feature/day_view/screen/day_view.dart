import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart'; // https://pub.dev/packages/flutter_week_view
import 'package:intl/date_symbol_data_local.dart';
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
              description: data.id.toString(),
              padding: const EdgeInsets.all(10),
            ));
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ja");
    const Locale("ja");
    DateTime now = DateTime.now();
    String formattedDate =
        '${DateFormat.yMMMd('ja').format(now)}(${DateFormat.E('ja').format(now)})';
    int daysCountFromBirth = now.difference(DateTime(2023, 6, 6)).inDays;

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
            dateFormatter: (int year, int month, int day) =>
                '生後$daysCountFromBirth日'),
        onBackgroundTappedDown: (DateTime dateTime) {
          dateTime = roundTimeToFitGrid(dateTime);
          showModalBottomSheetForRegister(
              context, formattedDate, dateTime, events, feedViewModel);
        },
        dragAndDropOptions: DragAndDropOptions(
          onEventDragged:
              (FlutterWeekViewEvent event, DateTime newStartTime) async {
            DateTime roundedTime = roundTimeToFitGrid(newStartTime,
                gridGranularity: const Duration(minutes: 15));

            var findResult = await feedViewModel.findById(int.parse(
                event.description)); // event.descriptionに idを Stringで保存してある

            if (findResult.isSuccess) {
              final targetFeed = findResult.dataOrThrow[0];
              final FeedModel newFeed = targetFeed.copyWith(
                  feedAt: roundedTime, updatedAt: DateTime.now());
              final saveResult = await feedViewModel.save(newFeed);

              if (saveResult.isSuccess) {
                setState(() {
                  event.shiftEventTo(roundedTime);
                });
              }
            }
          },
        ),
      ),
    );
  }
}
