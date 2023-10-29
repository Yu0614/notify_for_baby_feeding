import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart'; // https://pub.dev/packages/flutter_week_view
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'; // https://pub.dev/packages/flutter_datetime_picker_plus

import 'package:intl/intl.dart';

void _settingModalBottomSheet(context, formattedDate, dateTime) {
  final formKey = GlobalKey<FormState>();
  final dateTimeInputController = TextEditingController();

  double screenHeight = MediaQuery.of(context).size.height;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true, //  画面半分よりも大きなモーダルの表示設定
      showDragHandle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: screenHeight * 0.7,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Container(
                        height: screenHeight * 0.7,
                        decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            // backgroundColor: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Text('新規で登録',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(formattedDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(dateTime.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: dateTimeInputController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                labelText: '時間',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              ),
                              onTap: () {
                                DatePicker.showTimePicker(context,
                                    showTitleActions: true,
                                    showSecondsColumn: true, onChanged: (date) {
                                  dateTimeInputController.text =
                                      date.toString();
                                  print(date.toString());
                                }, onConfirm: (date) {
                                  print(date.toString());
                                  dateTimeInputController.text =
                                      date.toString();
                                },
                                    currentTime: dateTime,
                                    locale: LocaleType.jp);
                              },
                            ),
                            TextFormField(
                              maxLines: 2,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.face),
                                labelText: '特記事項',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              ),
                              onSaved: (newValue) {
                                // memo = newValue.toString();
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      });
}

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
        initialTime: HourMinute.fromDateTime(
            dateTime: now.copyWith(
                minute: now.minute - 30)), // 常に現在時から描画してしまうので30分ずらす
        date: now,
        dayBarStyle: DayBarStyle.fromDate(
            date: now,
            dateFormatter: (int year, int month, int day) => '生後xx日'),
        onBackgroundTappedDown: (DateTime dateTime) {
          dateTime = roundTimeToFitGrid(dateTime);
          _settingModalBottomSheet(context, formattedDate, dateTime);
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
