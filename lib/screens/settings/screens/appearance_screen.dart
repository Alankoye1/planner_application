import 'package:flutter/material.dart';
import 'package:planner/screens/settings/widgets/custom_setting_switch_tile.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  bool isDarkMode = false;
  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance Settings')),
      body: ListView(
        children: [
          CustomSettingSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: isDarkMode,
            // TODO: Implement dark mode functionality
            onChanged: (val) {
              setState(() => isDarkMode = val);
            },
          ),
          const Divider(),
          // TODO: Implement font size functionality
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              min: 12,
              max: 24,
              divisions: 6,
              value: fontSize,
              label: fontSize.toStringAsFixed(0),
              onChanged: (val) {
                setState(() => fontSize = val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
