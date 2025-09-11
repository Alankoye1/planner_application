import 'package:flutter/material.dart';
import 'package:planner/screens/settings/screens/about_screen.dart';
import 'package:planner/screens/settings/screens/account_screen.dart';
import 'package:planner/screens/settings/screens/appearance_screen.dart';
import 'package:planner/screens/settings/screens/notification_setting_screen.dart';
import 'package:planner/screens/settings/screens/privacy_screen.dart';
import 'package:planner/screens/settings/widgets/custom_setting_list_tile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  final List<SettingItem> _settingItems = [
    SettingItem(
      icon: Icons.person,
      title: 'Account',
      subtitle: 'Manage your account',
      color: Colors.blue,
      route: () => const AccountScreen(),
    ),
    SettingItem(
      icon: Icons.notifications,
      title: 'Notifications',
      subtitle: 'Notification preferences',
      color: Colors.orange,
      route: () => const NotificationSettingScreen(),
    ),
    SettingItem(
      icon: Icons.lock,
      title: 'Privacy',
      subtitle: 'Privacy settings',
      color: Colors.green,
      route: () => const PrivacyScreen(),
    ),
    SettingItem(
      icon: Icons.palette,
      title: 'Appearance',
      subtitle: 'Theme and display',
      color: Colors.purple,
      route: () => const AppearanceScreen(),
    ),
    SettingItem(
      icon: Icons.info,
      title: 'About',
      subtitle: 'App information',
      color: Colors.grey,
      route: () => const AboutScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimations = List.generate(_settingItems.length, (index) {
      return Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.4 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _fadeAnimations = List.generate(_settingItems.length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.4 + (index * 0.1),
          curve: Curves.easeInOut,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFE2E8F0),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade50,
                        Colors.purple.shade50,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _settingItems[index];
                    return SlideTransition(
                      position: _slideAnimations[index],
                      child: FadeTransition(
                        opacity: _fadeAnimations[index],
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: CustomSettingListTile(
                            icon: item.icon,
                            title: item.title,
                            subtitle: item.subtitle,
                            iconColor: item.color,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => item.route(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _settingItems.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget Function() route;

  SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}
