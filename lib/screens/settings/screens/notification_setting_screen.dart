import 'package:flutter/material.dart';
import 'package:planner/providers/notification_api.dart';
import 'package:planner/screens/settings/widgets/custom_setting_switch_tile.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen>
    with TickerProviderStateMixin {
  bool _enabled = false;
  TimeOfDay? _time;
  bool _loading = true;
  bool _busy = false;
  bool _exact = false; // allow user to force exact scheduling

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

    _slideAnimations = List.generate(3, (index) {
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

    _fadeAnimations = List.generate(3, (index) {
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

    _init();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await NotificationApi().initNotification();
    final t = await NotificationApi().getPersistedReminderTime();
    setState(() {
      _time = t;
      _enabled = t != null;
      _loading = false;
    });
    _animationController.forward();
  }

  Future<void> _toggle(bool value) async {
    setState(() => _enabled = value);
    if (!value) {
      await NotificationApi().cancelDailyReminder();
      setState(() => _time = null);
    } else {
      await _pickTime(initial: true);
    }
  }

  Future<void> _pickTime({bool initial = false}) async {
    if (_busy) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
      helpText: 'Select Daily Reminder Time',
    );
    if (picked != null) {
      setState(() => _busy = true);
      await NotificationApi().scheduleDailyReminder(picked, exact: _exact);
      if (mounted) {
        setState(() {
          _time = picked;
          _busy = false;
        });
      }
    } else if (initial) {
      // User cancelled initial selection; disable toggle
      setState(() => _enabled = false);
    }
  }

  String _format(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final suffix = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }

  Widget _buildTimePickerCard() {
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _enabled ? _pickTime : null,
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
                            colorScheme.secondary.withValues(alpha: 0.1),
                            colorScheme.secondary.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.schedule,
                        color: colorScheme.secondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reminder Time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _enabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _enabled
                                ? (_time != null
                                    ? 'Daily at ${_format(_time!)}'
                                    : 'Not set')
                                : 'Disabled',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Trailing
                    if (_busy)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        ),
                      )
                    else if (_enabled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Change',
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
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
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Daily Reminder',
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
                                title: 'Daily Reminder',
                                subtitle: 'Send a local notification every day',
                                value: _enabled,
                                onChanged: _toggle,
                                icon: Icons.notifications,
                                iconColor: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        
                        _buildTimePickerCard(),
                        
                        if (_enabled)
                          SlideTransition(
                            position: _slideAnimations[2],
                            child: FadeTransition(
                              opacity: _fadeAnimations[2],
                              child: Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: CustomSettingSwitchTile(
                                  title: 'Exact Timing',
                                  subtitle: 'Force precise trigger time (may use more battery)',
                                  value: _exact,
                                  onChanged: (v) async {
                                    setState(() => _exact = v);
                                    if (_time != null) {
                                      setState(() => _busy = true);
                                      await NotificationApi().scheduleDailyReminder(
                                        _time!,
                                        exact: _exact,
                                      );
                                      if (mounted) setState(() => _busy = false);
                                    }
                                  },
                                  icon: Icons.timer,
                                  iconColor: colorScheme.secondary,
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
