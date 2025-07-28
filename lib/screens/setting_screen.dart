import 'package:flutter/material.dart';
import 'package:planner/widgets/custom_setting_list_tile.dart';

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
              // TODO: Navigate to account settings
            },
          ),
          Divider(),
          CustomSettingListTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Notification preferences',
            onTap: () {
              // TODO: Navigate to notification settings
            },
          ),
          Divider(),
          CustomSettingListTile(
            icon: Icons.lock,
            title: 'Privacy',
            subtitle: 'Privacy settings',
            onTap: () {
              // TODO: Navigate to privacy settings
            },
          ),
          Divider(),
          CustomSettingListTile(
            title: 'Appearance',
            subtitle: 'Theme and display',
            icon: Icons.palette,
            onTap: () {
              // TODO: Navigate to appearance settings
            },
          ),
          Divider(),
          CustomSettingListTile(
            title: 'About',
            subtitle: 'App information',
            icon: Icons.info,
            onTap: () {
              // TODO: Navigate to about settings
            },
          ),
        ],
      ),
    );
  }
}
