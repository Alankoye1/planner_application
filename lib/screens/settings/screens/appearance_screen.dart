import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planner/providers/theme_provider.dart';
import 'package:planner/screens/settings/widgets/custom_setting_switch_tile.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance Settings')),
      body: ListView(
        children: [
          CustomSettingSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: themeProvider.isDarkMode,
            onChanged: (val) async {
              // Use await to ensure the theme is fully toggled
              await themeProvider.toggleTheme(val);
              // Force a rebuild of this widget after theme changes
              if (mounted) setState(() {});
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
