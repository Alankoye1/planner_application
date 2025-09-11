import 'package:flutter/material.dart';
import 'package:planner/screens/settings/widgets/custom_setting_switch_tile.dart';
import 'package:planner/screens/settings/widgets/custom_setting_list_tile.dart';
import 'package:planner/screens/settings/widgets/show_privacy.dart';

// TODO: Implement privacy settings functionality after implementing user authentication and data persistence
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen>
    with TickerProviderStateMixin {
  bool isProfilePrivate = false;
  bool allowSearch = true;
  bool personalizedAds = false;

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          0.4 + (index * 0.2),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _fadeAnimations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.2,
          0.4 + (index * 0.2),
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
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Privacy Settings',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.tertiaryContainer,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SlideTransition(
                    position: _slideAnimations[0],
                    child: FadeTransition(
                      opacity: _fadeAnimations[0],
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomSettingSwitchTile(
                          title: 'Private Profile',
                          subtitle: 'Only approved users can see your profile',
                          value: isProfilePrivate,
                          onChanged: (val) {
                            setState(() => isProfilePrivate = val);
                          },
                          icon: Icons.visibility_off,
                          iconColor: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  
                  SlideTransition(
                    position: _slideAnimations[1],
                    child: FadeTransition(
                      opacity: _fadeAnimations[1],
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomSettingSwitchTile(
                          title: 'Allow Search',
                          subtitle: 'Allow others to find you by email or username',
                          value: allowSearch,
                          onChanged: (val) {
                            setState(() => allowSearch = val);
                          },
                          icon: Icons.search,
                          iconColor: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  
                  SlideTransition(
                    position: _slideAnimations[2],
                    child: FadeTransition(
                      opacity: _fadeAnimations[2],
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomSettingSwitchTile(
                          title: 'Personalized Ads',
                          subtitle: 'Allow personalized ads based on your activity',
                          value: personalizedAds,
                          onChanged: (val) {
                            setState(() => personalizedAds = val);
                          },
                          icon: Icons.ads_click,
                          iconColor: colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                  
                  SlideTransition(
                    position: _slideAnimations[3],
                    child: FadeTransition(
                      opacity: _fadeAnimations[3],
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomSettingListTile(
                          title: 'Privacy Policy',
                          subtitle: 'Read our privacy policy',
                          icon: Icons.info_outline,
                          iconColor: colorScheme.secondary,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => const ShowPrivacy(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
