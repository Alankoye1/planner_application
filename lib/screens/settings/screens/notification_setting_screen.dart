import 'package:flutter/material.dart';
import 'package:planner/providers/notification_api.dart';
import 'package:planner/screens/settings/widgets/custom_setting_switch_tile.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool _enabled = false;
  TimeOfDay? _time;
  bool _loading = true;
  bool _busy = false;
  bool _exact = false; // allow user to force exact scheduling

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await NotificationApi().initNotification();
    final t = await NotificationApi().getPersistedReminderTime();
    setState(() {
      _time = t;
      _enabled = t != null;
      _loading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Reminder')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                CustomSettingSwitchTile(
                  title: 'Daily Reminder',
                  subtitle: 'Send a local notification every day',
                  value: _enabled,
                  onChanged: (v) => _toggle(v),
                ),
                const Divider(),
                ListTile(
                  enabled: _enabled && !_busy,
                  leading: const Icon(Icons.schedule),
                  title: const Text('Reminder Time'),
                  subtitle: Text(
                    _enabled
                        ? (_time != null
                              ? 'Daily at ${_format(_time!)}'
                              : 'Not set')
                        : 'Disabled',
                  ),
                  trailing: _busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : (_enabled
                            ? TextButton(
                                onPressed: _pickTime,
                                child: const Text('Change'),
                              )
                            : null),
                  onTap: _enabled ? _pickTime : null,
                ),
                if (_enabled)
                  SwitchListTile.adaptive(
                    title: const Text('Exact (may use more battery)'),
                    subtitle: const Text('Force precise trigger time'),
                    value: _exact,
                    onChanged: (v) async {
                      setState(() => _exact = v);
                      if (_time != null) {
                        // Reschedule with new mode
                        setState(() => _busy = true);
                        await NotificationApi().scheduleDailyReminder(
                          _time!,
                          exact: _exact,
                        );
                        if (mounted) setState(() => _busy = false);
                      }
                    },
                  ),
              ],
            ),
    );
  }
}
