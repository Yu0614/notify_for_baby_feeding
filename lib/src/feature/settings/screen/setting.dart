import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Expanded(
            child: SettingsList(
          sections: [
            SettingsSection(
              title: const Padding(
                padding: EdgeInsets.only(
                    top: 50, //上４
                    left: 10, //左８
                    right: 10, //右８
                    bottom: 10 //下４
                    ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("設定",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ),
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  value: const Text('日本語'),
                ),
              ],
            ),
          ],
        ) // constrain height
            )
      ],
    ));
  }
}
