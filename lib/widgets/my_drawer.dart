import 'package:flutter/material.dart';
import 'package:planner/providers/user_provider.dart';
import 'package:planner/screens/bmi_screen.dart';
import 'package:planner/screens/calory_calculate_screen.dart';
import 'package:planner/screens/favorite_screen.dart';
import 'package:planner/screens/settings/screens/setting_screen.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  final List<DrawerItem> _drawerItems = [
    DrawerItem(
      icon: Icons.calculate,
      title: 'BMI Calculator',
      subtitle: 'Check your body mass index',
      colorKey: 'primary',
    ),
    DrawerItem(
      icon: Icons.local_fire_department,
      title: 'Calorie Tracker',
      subtitle: 'Track your daily calories',
      colorKey: 'secondary',
    ),
    DrawerItem(
      icon: Icons.favorite,
      title: 'Favorites',
      subtitle: 'Your favorite exercises',
      colorKey: 'error',
    ),
    DrawerItem(
      icon: Icons.settings,
      title: 'Settings',
      subtitle: 'App preferences',
      colorKey: 'outline',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimations = List.generate(_drawerItems.length, (index) {
      final start = index * 0.08;
      final end = (0.3 + (index * 0.08)).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          start,
          end,
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _fadeAnimations = List.generate(_drawerItems.length, (index) {
      final start = index * 0.08;
      final end = (0.3 + (index * 0.08)).clamp(0.0, 1.0);
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          start,
          end,
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

  Color _getColorFromKey(String colorKey, ColorScheme colorScheme) {
    switch (colorKey) {
      case 'primary':
        return colorScheme.primary;
      case 'secondary':
        return colorScheme.secondary;
      case 'error':
        return colorScheme.error;
      case 'outline':
        return colorScheme.outline;
      default:
        return colorScheme.primary;
    }
  }

  Widget _buildDrawerItem({
    required DrawerItem item,
    required VoidCallback onTap,
    required int index,
    required ColorScheme colorScheme,
  }) {
    final itemColor = _getColorFromKey(item.colorKey, colorScheme);
    
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            itemColor.withValues(alpha: 0.2),
                            itemColor.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: itemColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom Header
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Avatar
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Consumer<UserProvider>(
                                builder: (context, userProvider, child) {
                                  return CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: userProvider.getProfileImageWidget(
                                        width: 70.0,
                                        height: 70.0,
                                        fit: BoxFit.cover,
                                      ) ?? Icon(
                                        Icons.person,
                                        size: 45,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // User Info
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Column(
                              children: [
                                Text(
                                  userProvider.currentUser?.username ?? 'Guest',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Fitness Enthusiast',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Menu Items
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Features',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Menu Items
                      _buildDrawerItem(
                        item: _drawerItems[0],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const BmiScreen()),
                          );
                        },
                        index: 0,
                        colorScheme: colorScheme,
                      ),
                      _buildDrawerItem(
                        item: _drawerItems[1],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CaloryCalculateScreen(),
                            ),
                          );
                        },
                        index: 1,
                        colorScheme: colorScheme,
                      ),
                      _buildDrawerItem(
                        item: _drawerItems[2],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                          );
                        },
                        index: 2,
                        colorScheme: colorScheme,
                      ),
                      _buildDrawerItem(
                        item: _drawerItems[3],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const SettingScreen()),
                          );
                        },
                        index: 3,
                        colorScheme: colorScheme,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // App Version
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1400),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Center(
                              child: Text(
                                'Fitness Planner v1.0',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String colorKey;

  DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorKey,
  });
}
