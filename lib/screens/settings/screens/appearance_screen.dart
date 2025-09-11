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

class _AppearanceScreenState extends State<AppearanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimations = List.generate(2, (index) {
      return Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.3,
          0.4 + (index * 0.3),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _fadeAnimations = List.generate(2, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.3,
          0.4 + (index * 0.3),
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

  Widget _buildFontSizeCard(FontProvider fontProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SlideTransition(
      position: _slideAnimations[1],
      child: FadeTransition(
        opacity: _fadeAnimations[1],
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.tertiary.withValues(alpha: 0.1),
                        colorScheme.tertiary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.text_fields,
                    color: colorScheme.tertiary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Font Size',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${fontProvider.fontSize.toStringAsFixed(0)}px',
                              style: TextStyle(
                                color: colorScheme.tertiary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: colorScheme.tertiary,
                          inactiveTrackColor: colorScheme.tertiary.withValues(alpha: 0.2),
                          thumbColor: colorScheme.tertiary,
                          overlayColor: colorScheme.tertiary.withValues(alpha: 0.1),
                          valueIndicatorColor: colorScheme.tertiary,
                          trackHeight: 4,
                        ),
                        child: Slider(
                          min: 12,
                          max: 22,
                          divisions: 10,
                          value: fontProvider.fontSize,
                          label: '${fontProvider.fontSize.toStringAsFixed(0)}px',
                          onChanged: (val) {
                            setState(() {
                              fontProvider.setFontSize(val);
                            });
                          },
                        ),
                      ),
                      Text(
                        'Adjust text size throughout the app',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
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
                  'Appearance Settings',
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
                        colorScheme.secondaryContainer,
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
                          title: 'Dark Mode',
                          subtitle: 'Enable dark theme',
                          value: themeProvider.isDarkMode,
                          onChanged: (val) async {
                            await themeProvider.toggleTheme(val);
                            if (mounted) setState(() {});
                          },
                          icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          iconColor: themeProvider.isDarkMode ? colorScheme.secondary : colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  
                  _buildFontSizeCard(fontProvider),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
