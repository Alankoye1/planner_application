import 'package:flutter/material.dart';
import 'package:planner/providers/font_provider.dart';
import 'package:provider/provider.dart';
import 'package:planner/providers/theme_provider.dart';
import 'package:planner/screens/settings/widgets/custom_setting_switch_tile.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  // double fontSize = 16.0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    return Scaffold(
  appBar: AppBar(title: const Text('Appearance Settings')),
      body: ListView(
        children: [
          CustomSettingSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: themeProvider.isDarkMode,
            onChanged: (val) async {
              await themeProvider.toggleTheme(val);
              if (mounted) setState(() {});
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              min: 12,
              max: 22,
              divisions: 6,
              value: fontProvider.fontSize,
              label: fontProvider.fontSize.toStringAsFixed(0),
              onChanged: (val) {
                setState(() {
                  fontProvider.setFontSize(val);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
