import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
          sections: [
            SettingsSection(
              title: const Padding(
                padding: EdgeInsets.only(
                    top: 50,
                    left: 5,
                    right: 10,
                    bottom: 20
                    ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("設定",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ),
              ),
              tiles: <SettingsTile>[
                SettingsTile(
                    leading: const Icon(Icons.info),
                    title: const Text('アプリのバージョン'),
                    value: Text("${snapshot.data?.version}"))
              ],
            ),
          ],
        ) // constrain height
            )
      ],
    ));
  }
}
