import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_week_view/flutter_week_view.dart'; // https://pub.dev/packages/flutter_week_view

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'; // https://pub.dev/packages/flutter_datetime_picker_plus

import 'package:intl/intl.dart';
import 'package:notify_for_baby_feeding/models/feed/feed.dart';

void showModalBottomSheetForRegister(context, dateTime, events, feedViewModel) {
  String formattedDate;
  const formatType = 'yyyy-MM-dd HH:mm';
  final formKey = GlobalKey<FormState>();
  final dateTimeInputController =
      TextEditingController(text: DateFormat(formatType).format(dateTime));
  final amountInputController = TextEditingController(text: "");
  final memoInputController = TextEditingController(text: "");

  const screenHeightMagnification = 0.5;
  double screenHeight =
      MediaQuery.of(context).size.height * screenHeightMagnification;

  bool isInputting = false;

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
            return GestureDetector(
              onTap: () => {
                FocusManager.instance.primaryFocus?.unfocus(),
                isInputting = false
              },
              behavior: HitTestBehavior.opaque, // これを追加！！！
              child: SizedBox(
                height: isInputting
                    ? screenHeight + MediaQuery.of(context).viewInsets.bottom
                    : screenHeight,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Container(
                          height: isInputting
                              ? screenHeight +
                                  MediaQuery.of(context).viewInsets.bottom
                              : screenHeight,
                          decoration: const BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              // backgroundColor: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'キャンセル',
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  ),
                                  const Text('新規登録',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        FeedModel feed = FeedModel.fromJson({
                                          "memo": memoInputController.text,
                                          "amount": int.parse(
                                              amountInputController.text),
                                          "feed_at": DateTime.parse(
                                                  dateTimeInputController.text)
                                              .toIso8601String()
                                          //dateTime.toIso8601String()
                                        });

                                        final res =
                                            await feedViewModel.save(feed);

                                        if (res.isFailure) {
                                          return;
                                        }

                                        setState(() {
                                          final event = FlutterWeekViewEvent(
                                            title:
                                                "ミルク ${events.length + 1} 回目 ${feed.amount} ml",
                                            start: DateTime.parse(
                                                dateTimeInputController.text),
                                            end: dateTime.add(
                                                const Duration(minutes: 45)),
                                            description: res.dataOrThrow[0].id
                                                .toString(),
                                            padding: const EdgeInsets.all(10),
                                          );
                                          events.add(event);

                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    child: const Text(
                                      '登録する',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'ミルクを飲んだ量と時間を登録します',
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: dateTimeInputController,
                                keyboardType: TextInputType.none,
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
                                      showSecondsColumn: false,
                                      onChanged: (date) {
                                    formattedDate =
                                        DateFormat(formatType).format(date);
                                    dateTimeInputController.text =
                                        formattedDate;
                                  }, onConfirm: (date) {
                                    formattedDate =
                                        DateFormat(formatType).format(date);
                                    dateTimeInputController.text =
                                        formattedDate;
                                  },
                                      currentTime: dateTime,
                                      locale: LocaleType.jp);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "時間を入力してください。";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: amountInputController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                decoration: const InputDecoration(
                                  counterText: '',
                                  icon: Icon(Icons.water_drop_outlined),
                                  labelText: 'ml',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                                onTap: () => {isInputting = true},
                                onFieldSubmitted: (value) =>
                                    {isInputting = false},
                                onTapOutside: (value) => {isInputting = false},
                                onChanged: (newValue) {
                                  amountInputController.text =
                                      newValue.toString();
                                },
                                validator: (value) {
                                  if (value == null || value.length < 2) {
                                    return "飲んだ量を入力してください。";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: memoInputController,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.face),
                                  labelText: 'メモ',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                                onTap: () => isInputting = true,
                                onTapOutside: (v) => isInputting = false,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
}
