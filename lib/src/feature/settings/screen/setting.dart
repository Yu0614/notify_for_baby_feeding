import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SettingsPage extends StatefulHookWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<StatefulHookWidget> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isNotificationEnable = false; // このアプリの通知
  bool isApplicationNotifyEnable = false; // iOSアプリとしての通知
  late int notifyTimeDuration = 0;

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
    if (result != null && result) {
      setState(() {
        isApplicationNotifyEnable = true;
      });
    }
    return result;
  }

  Future<void> scheduledNotification() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));

    if (isNotificationEnable) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // id
        'ミルク管理', // title
        'テスト通知', // body
        tz.TZDateTime.now(tz.local)
            .add(const Duration(seconds: 5)), // scheduledDateTime
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            badgeNumber: null,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  dynamic switchNotifyEnable() async {
    var prefs = await SharedPreferences.getInstance();
    var currentEnable = prefs.getBool("enable_notify") ?? false;
    await prefs.setBool("enable_notify", !currentEnable);
    setState(() {
      isNotificationEnable = !isNotificationEnable;
    });
  }

  @override
  void initState() {
    super.initState();

    Future(
      () async {
        await initializeNotification();
        var prefs = await SharedPreferences.getInstance();

        var tmpTimeDuration = prefs.getInt("notify_time_duration");
        if (tmpTimeDuration == null) {
          prefs.setInt("notify_time_duration", 4);
        }

        setState(() {
          notifyTimeDuration = tmpTimeDuration!;
        });

        final bool? enableNotify = prefs.getBool("enable_notify");

        if (enableNotify != null) {
          setState(() {
            isNotificationEnable = enableNotify;
          });
        } else {
          setState(() {
            isNotificationEnable = false;
          });
        }

        // 通知設定の初期化
        WidgetsFlutterBinding.ensureInitialized();
        var res = await requestPermission();

        setState(() {
          isApplicationNotifyEnable = res!;
        });
      },
    );
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
                    var res = await requestPermission();

                    if (res == true) {
                      switchNotifyEnable();
                    }
                  },
                ),
                SettingsTile(
                    leading: const Icon(Icons.notification_important_sharp),
                    title: const Text('アプリ自体の通知許可状態'),
                    value: Text(isApplicationNotifyEnable ? "許可する" : "許可しない")),
                SettingsTile(
                  leading: const Icon(Icons.punch_clock_sharp),
                  title: const Text('通知の間隔'),
                  value: Text('$notifyTimeDuration時間'),
                  onPressed: (context) => scheduledNotification(),
                ),
              ],
            )
          ],
        ) // constrain height
            )
      ],
    ));
  }
}
