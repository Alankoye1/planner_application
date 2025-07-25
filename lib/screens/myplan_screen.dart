import 'package:flutter/material.dart';
import 'package:planner/screens/custom_excercise_screen.dart';
import 'package:planner/screens/schedule_screen.dart';
import 'package:planner/widgets/navigation_screen.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';

class MyplanScreen extends StatefulWidget {
  const MyplanScreen({super.key});

  @override
  State<MyplanScreen> createState() => _MyplanScreenState();
}

class _MyplanScreenState extends State<MyplanScreen> {
  bool _isSchedule = true;

  // change the state of the screen based on the navigation toggle
  @override
  void didChangeDependencies() {
    setState(() {
      print( '_isSchedule: $_isSchedule');
    });
    super.didChangeDependencies();
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
              print('Navigation toggled: $_isSchedule');
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isSchedule ? ScheduleScreen() : CustomExerciseScreen(),
          ),
        ],
      ),
    );
  }

  

 
}