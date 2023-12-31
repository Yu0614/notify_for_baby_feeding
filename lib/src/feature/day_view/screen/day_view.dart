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

  findFeed(FeedModel newFeed) async {
    var res = await feedViewModel.findById(newFeed.id as int);
    return res.dataOrThrow[0];
  }

  createEventCallBack(
      String title, DateTime start, String description, FeedModel feed) {
    logger.i("createEvent!");

    final event = FlutterWeekViewEvent(
      title: title,
      start: start,
      end: start.add(const Duration(minutes: 45)),
      description: description,
      padding: const EdgeInsets.all(10),
      onTap: () {
        showModalCallBack(feed);
      },
    );

    setState(() {
      events.add(event);
    });
  }

  showModalCallBack(FeedModel newFeed) async {
    final feed = await findFeed(newFeed);

    // ignore: use_build_context_synchronously
    showModalBottomSheetForRegister(
        context,
        feed.feedAt!,
        events,
        feedViewModel,
        feed,
        createEventCallBack,
        deleteEventCallBack,
        editEventCallBack);
  }

  editEventCallBack(FeedModel feed, int index) {
    setState(() {
      events.removeAt(index);
    });

    final startTime = DateTime.parse(feed.feedAt!.toIso8601String());
    final title = "🍼 ${index + 1} 回目 ${feed.amount} ml";
    final description = feed.id.toString();
    createEventCallBack(title, startTime, description, feed);
  }

  deleteEventCallBack(FlutterWeekViewEvent event) {
    setState(() {
      events.remove(event);
    });
  }

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        result = await feedViewModel.loadByDate(DateTime.now());
        for (final data in result.dataOrThrow) {
          final feedAt = data.feedAt;
          final title = "🍼 ${events.length + 1} 回目 ${data.amount} ml";
          final description = data.id.toString();
          final start = DateTime.parse(feedAt!.toIso8601String());

          createEventCallBack(title, start, description, data);
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
              showModalBottomSheetForRegister(context, roundTimeToFitGrid(now),
                  events, feedViewModel, null, createEventCallBack);
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
          showModalBottomSheetForRegister(context, dateTime, events,
              feedViewModel, null, createEventCallBack);
        },
        dragAndDropOptions: DragAndDropOptions(
          startingGesture: DragStartingGesture.longPress,
          onEventDragged:
              (FlutterWeekViewEvent event, DateTime newStartTime) async {
            DateTime roundedTime = roundTimeToFitGrid(newStartTime,
                gridGranularity: const Duration(minutes: 15));

            var findResult = await feedViewModel.findById(int.parse(
                event.description)); // event.descriptionに idを Stringで保存してある

            if (findResult.isSuccess) {
              final targetFeed = findResult.dataOrThrow[0];
              final FeedModel newFeed = targetFeed.copyWith(
                feedAt: roundedTime,
              );
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
