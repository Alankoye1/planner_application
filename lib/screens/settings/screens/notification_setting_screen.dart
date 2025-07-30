import 'package:flutter/material.dart';
import 'package:planner/screens/settings/widgets/custom_setting_switch_tile.dart';

// TODO: Implement notification settings functionality after implementing user authentication and data persistence
class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool reminderNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        children: [
          CustomSettingSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: pushNotifications,
            onChanged: (val) {
              setState(() => pushNotifications = val);
            },
          ),
          const Divider(),
          CustomSettingSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: emailNotifications,
            onChanged: (val) {
              setState(() => emailNotifications = val);
            },
          ),
          const Divider(),
          CustomSettingSwitchTile(
            title: 'Reminders',
            subtitle: 'Get reminders for your plans',
            value: reminderNotifications,
            onChanged: (val) {
              setState(() => reminderNotifications = val);
            },
          ),
        ],
      ),
    );
  }
}
