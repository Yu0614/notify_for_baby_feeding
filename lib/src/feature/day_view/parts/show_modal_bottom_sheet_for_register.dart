import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter_week_view/flutter_week_view.dart'; // https://pub.dev/packages/flutter_week_view
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'; // https://pub.dev/packages/flutter_datetime_picker_plus

import 'package:notify_for_baby_feeding/models/feed/feed.dart';
import 'package:notify_for_baby_feeding/view_models/day_view/feed_view_model.dart';

void showModalBottomSheetForRegister(
  BuildContext context,
  DateTime dateTime,
  List<FlutterWeekViewEvent> events,
  FeedViewModel feedViewModel, [
  FeedModel? targetFeed,
  Function? createEventCallBack,
  Function? deleteCallback,
  Function? editCallback,
]) {
  String formattedDate;
  const formatType = 'yyyy-MM-dd HH:mm';

  bool isTargetFeedExist = (targetFeed != null);
  bool isInputting = false;
  final modalTitle = isTargetFeedExist ? " 編集" : "新規登録";
  final modalButtonText = isTargetFeedExist ? "変更を反映する" : "登録する";
  final informationText =
      isTargetFeedExist ? "ミルクを飲んだ量と時間を変更します" : "ミルクを飲んだ量と時間を登録します";

  final formKey = GlobalKey<FormState>();
  final dateTimeInputController =
      TextEditingController(text: DateFormat(formatType).format(dateTime));
  final amountInputController = TextEditingController(
      text: isTargetFeedExist ? targetFeed.amount.toString() : "");
  final memoInputController =
      TextEditingController(text: isTargetFeedExist ? targetFeed.memo : "");
  final screenHeightMagnification = isTargetFeedExist ? 0.53 : 0.5;
  double screenHeight =
      MediaQuery.of(context).size.height * screenHeightMagnification;

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
                                  Text(modalTitle,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        FeedModel feed = FeedModel.fromJson({
                                          "id": isTargetFeedExist
                                              ? targetFeed.id
                                              : null,
                                          "memo": memoInputController.text,
                                          "amount": int.parse(
                                              amountInputController.text),
                                          "feed_at": DateTime.parse(
                                                  dateTimeInputController.text)
                                              .toIso8601String(),
                                          "created_at": isTargetFeedExist
                                              ? targetFeed.createdAt
                                                  ?.toIso8601String()
                                              : null,
                                        });

                                        final res =
                                            await feedViewModel.save(feed);

                                        if (res.isFailure) {
                                          return;
                                        }

                                        int eventIndex;

                                        if (isTargetFeedExist) {
                                          eventIndex = events.indexWhere(
                                              (item) =>
                                                  item.description ==
                                                  targetFeed.id.toString());

                                          editCallback?.call(feed, eventIndex);

                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        } else {
                                          final title =
                                              "🍼 ${events.length + 1} 回目 ${feed.amount} ml";
                                          final start = DateTime.parse(
                                              dateTimeInputController.text);

                                          final description =
                                              res.dataOrThrow[0].id.toString();

                                          createEventCallBack!(
                                            title,
                                            start,
                                            description,
                                            res.dataOrThrow[0],
                                          );

                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    },
                                    child: Text(
                                      modalButtonText,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(informationText),
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
                              const SizedBox(height: 5),
                              Visibility(
                                visible: isTargetFeedExist,
                                child: TextButton(
                                    onPressed: () {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoActionSheet(
                                            title: const Text('この記録を削除しますか？'),
                                            actions: [
                                              CupertinoActionSheetAction(
                                                child: const Text(
                                                  '記録を削除',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                onPressed: () => {
                                                  Navigator.of(context).pop()
                                                },
                                              ),
                                            ],
                                            cancelButton: CupertinoButton(
                                              child: const Text(
                                                'キャンセル',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const SizedBox(
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            '削除する',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ))),
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
