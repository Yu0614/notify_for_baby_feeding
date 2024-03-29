// import 'package:notify_for_baby_feeding/src/feature/demo/screen/week_view.dart';
import 'package:notify_for_baby_feeding/src/feature/day_view/screen/day_view.dart';
import 'package:notify_for_baby_feeding/src/feature/settings/screen/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:io';

/// First plugin test method.
void main() {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const NotifyForBabyFeedingApp());
  sleep(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
}

class NotifyForBabyFeedingApp extends StatelessWidget {
  const NotifyForBabyFeedingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Navigation(),
      initialRoute: '/',
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.lightBlue[200],
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_today),
            icon: Icon(Icons.calendar_today_outlined),
            label: '今日のミルク記録',
          ),
          // NavigationDestination(
          //   selectedIcon: Icon(Icons.calendar_month),
          //   icon: Icon(Icons.calendar_month_outlined),
          //   label: '今週の履歴',
          // ),
          // NavigationDestination(
          //   selectedIcon: Icon(Icons.analytics),
          //   icon: Icon(Icons.analytics_outlined),
          //   label: '分析レポート',
          // ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: '設定',
          ),
        ],
      ),
      body: <Widget>[
        const DynamicDayView(),
        // const DemoWeekView(),
        // Container(
        //   color: Colors.blue,
        //   alignment: Alignment.center,
        //   child: const Text('分析レポート'),
        // ),
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
