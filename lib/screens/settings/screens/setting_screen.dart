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

  final List<Map<String, dynamic>> _settingItems = [
    {
      'icon': Icons.person,
      'title': 'Account',
      'subtitle': 'Manage your account',
      'color': 'primary',
      'route': () => const AccountScreen(),
    },
    {
      'icon': Icons.notifications,
      'title': 'Notifications',
      'subtitle': 'Notification preferences',
      'color': 'secondary',
      'route': () => const NotificationSettingScreen(),
    },
    {
      'icon': Icons.lock,
      'title': 'Privacy',
      'subtitle': 'Privacy settings',
      'color': 'tertiary',
      'route': () => const PrivacyScreen(),
    },
    {
      'icon': Icons.palette,
      'title': 'Appearance',
      'subtitle': 'Theme and display',
      'color': 'primary',
      'route': () => const AppearanceScreen(),
    },
    {
      'icon': Icons.info,
      'title': 'About',
      'subtitle': 'App information',
      'color': 'outline',
      'route': () => const AboutScreen(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimations = List.generate(_settingItems.length, (index) {
      return Tween<Offset>(
        begin: const Offset(0.8, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.4 + (index * 0.1).clamp(0.0, 0.6),
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
          index * 0.08,
          0.4 + (index * 0.08).clamp(0.0, 0.6),
          curve: Curves.easeInOut,
        ),
      ));
    });

    // Add a slight delay before starting animations
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer.withValues(alpha: 0.8),
                        colorScheme.secondaryContainer.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          colorScheme.surface.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _settingItems[index];
                    return SlideTransition(
                      position: _slideAnimations[index],
                      child: FadeTransition(
                        opacity: _fadeAnimations[index],
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: CustomSettingListTile(
                            icon: item['icon'],
                            title: item['title'],
                            subtitle: item['subtitle'],
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => item['route'](),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOutCubic;

                                    var tween = Tween(begin: begin, end: end).chain(
                                      CurveTween(curve: curve),
                                    );

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 300),
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
