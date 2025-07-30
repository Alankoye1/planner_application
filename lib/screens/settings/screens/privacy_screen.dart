import 'package:flutter/material.dart';
import 'package:planner/screens/settings/widgets/custom_setting_switch_tile.dart';
import 'package:planner/screens/settings/widgets/show_privacy.dart';

// TODO: Implement privacy settings functionality after implementing user authentication and data persistence
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool isProfilePrivate = false;
  bool allowSearch = true;
  bool personalizedAds = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: ListView(
        children: [
          CustomSettingSwitchTile(
            title: 'Private Profile',
            subtitle: 'Only approved users can see your profile',
            value: isProfilePrivate,
            onChanged: (val) {
              setState(() => isProfilePrivate = val);
            },
          ),
          const Divider(),
          CustomSettingSwitchTile(
            title: 'Allow Search',
            subtitle: 'Allow others to find you by email or username',
            value: allowSearch,
            onChanged: (val) {
              setState(() => allowSearch = val);
            },
          ),
          const Divider(),
          CustomSettingSwitchTile(
            title: 'Personalized Ads',
            subtitle: 'Allow personalized ads based on your activity',
            value: personalizedAds,
            onChanged: (val) {
              setState(() => personalizedAds = val);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blueAccent),
            title: const Text('Privacy Policy'),
            subtitle: const Text('Read our privacy policy'),
            onTap: () => showDialog(
              context: context,
              builder: (context) => const ShowPrivacy(),
            ),
          ),
        ],
      ),
    );
  }
}
