import 'package:flutter/material.dart';
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
            child: _isSchedule ? _buildScheduleView() : _buildCustomView(),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleView() {
    return ListView.builder(
      itemCount: scheduledExercises.keys.length,
      itemBuilder: (context, index) {
        String day = scheduledExercises.keys.elementAt(index);
        List<Excercise> exercises = scheduledExercises[day]!;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            title: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text('${exercises.length} exercises'),
            children: exercises.isEmpty
                ? [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Rest Day',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ]
                : exercises
                    .map((exercise) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(exercise.excerciseImage),
                          ),
                          title: Text(exercise.excerciseTitle),
                          trailing: Checkbox(
                            value: false, // You can add state tracking here
                            onChanged: (value) {
                              // Handle exercise completion
                            },
                          ),
                        ))
                    .toList(),
          ),
        );
      },
    );
  }

  Widget _buildCustomView() {
    return const Center(
      child: Text(
        'Custom Workout View\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
      ),
    );
  }
}