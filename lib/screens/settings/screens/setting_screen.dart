import 'package:flutter/material.dart';
import 'package:planner/screens/settings/screens/about_screen.dart';
import 'package:planner/screens/settings/screens/account_screen.dart';
import 'package:planner/screens/settings/screens/appearance_screen.dart';
import 'package:planner/screens/settings/screens/notification_setting_screen.dart';
import 'package:planner/screens/settings/screens/privacy_screen.dart';
import 'package:planner/screens/settings/widgets/custom_setting_list_tile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          CustomSettingListTile(
            icon: Icons.person,
            title: 'Account',
            subtitle: 'Manage your account',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
          Divider(),
          CustomSettingListTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Notification preferences',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingScreen(),
                ),
              );
            },
          ),
          Divider(),
          CustomSettingListTile(
            icon: Icons.lock,
            title: 'Privacy',
            subtitle: 'Privacy settings',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
          ),
          Divider(),
          CustomSettingListTile(
            title: 'Appearance',
            subtitle: 'Theme and display',
            icon: Icons.palette,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AppearanceScreen(),
                ),
              );
            },
          ),
          Divider(),
          CustomSettingListTile(
            title: 'About',
            subtitle: 'App information',
            icon: Icons.info,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
