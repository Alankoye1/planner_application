import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/widgets/custom_excercise.dart';
import 'package:planner/widgets/schedule.dart';
import 'package:planner/widgets/navigation_screen.dart';
import 'package:planner/providers/custom_exercise_provider.dart';
import 'package:provider/provider.dart';

class MyplanScreen extends StatefulWidget {
  const MyplanScreen({super.key});

  @override
  State<MyplanScreen> createState() => _MyplanScreenState();
}

class _MyplanScreenState extends State<MyplanScreen> {
  bool _isSchedule = true;
  CustomExerciseProvider? _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_provider == null) {
      _provider = Provider.of<CustomExerciseProvider>(context, listen: false);
      _provider!.addListener(_updateUI);
    }
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_updateUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavigationScreen(
            onToggle: (isSchedule) {
              setState(() {
                _isSchedule = isSchedule;
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(child: _isSchedule ? Schedule() : CustomExercise()),
        ],
      ),
      floatingActionButton: !_isSchedule && customExercises.isNotEmpty
          ? Consumer<CustomExerciseProvider>(
              builder: (context, provider, child) {
                return FloatingActionButton(
                  onPressed: () {
                    provider.addingCustom(context);
                  },
                  child: const Icon(Icons.add),
                );
              },
            )
          : null,
    );
  }
}
