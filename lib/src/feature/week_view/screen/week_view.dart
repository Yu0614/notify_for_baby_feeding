import 'package:flutter/material.dart';

class WeekViewScreen extends StatelessWidget {
  const WeekViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('一週間の履歴'),
      ),
      body:
          const Center(child: Text('ホーム画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}
