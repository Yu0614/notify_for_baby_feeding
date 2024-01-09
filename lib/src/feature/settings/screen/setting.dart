import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsPage extends StatefulHookWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<StatefulHookWidget> {
  var isNotificationEnable = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  dynamic switchNotifyEnable() {
    setState(() {
      isNotificationEnable = !isNotificationEnable;
    });
  }

  Future<bool?> initializeNotification() async {
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: null,
      iOS: initializationSettingsIOS,
    );
    return await flutterLocalNotificationsPlugin
        .initialize(initializationSettings);
  }

  Future<bool?> requestPermission() async {
    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final fromPlatform = useMemoized(PackageInfo.fromPlatform);
    final snapshot = useFuture(fromPlatform);
    if (!snapshot.hasData) {
      return const SizedBox.shrink();
    }
    return Center(
        child: Column(
      children: [
        Expanded(
            child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: const Padding(
                padding:
                    EdgeInsets.only(top: 50, left: 0, right: 10, bottom: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("アプリについて",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ),
              ),
              tiles: <SettingsTile>[
                SettingsTile(
                    leading: const Icon(Icons.info_sharp),
                    title: const Text('アプリのバージョン'),
                    value: Text("${snapshot.data?.version}"))
              ],
            ),
            SettingsSection(
              title: const Padding(
                padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("通知設定",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  leading: const Icon(Icons.notifications_sharp),
                  title: const Text('ミルクを飲む時間に通知する'),
                  initialValue: isNotificationEnable,
                  onToggle: (v) async {
                    // 通知を許可してくれているか -> iOS
                    WidgetsFlutterBinding.ensureInitialized();
                    // 通知設定の初期化
                    var result = await initializeNotification();

                    if (result != null) {
                      // 通知を許可してくれているか
                      var permissionResult = await requestPermission();
                      print(permissionResult);

                      if (permissionResult != null) {
                        switchNotifyEnable();
                      }
                    }
                  },
                )
              ],
            )
          ],
        ) // constrain height
            )
      ],
    ));
  }
}
