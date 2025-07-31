import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final Map<String, bool> _completionStatus = {};
  
  // Helper method to create a unique key for each exercise based on day and ID
  String _getExerciseKey(String day, String exerciseId) {
    return '$day-$exerciseId';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: ListView.builder(
        itemCount: scheduledExercises.keys.length,
        itemBuilder: (context, index) {
          String day = scheduledExercises.keys.elementAt(index);
          List<Excercise> exercises = scheduledExercises[day]!;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(
                day,
                style: Theme.of(context).textTheme.headlineMedium,
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
                        .map(
                          (exercise) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                exercise.excerciseImage,
                              ),
                            ),
                            title: Text(exercise.excerciseTitle),
                            trailing: Checkbox(
                              value: _completionStatus[_getExerciseKey(day, exercise.id)] ?? false,
                              onChanged: (value) {
                                // Handle exercise completion
                                setState(() {
                                  _completionStatus[_getExerciseKey(day, exercise.id)] = value!;
                                });
                              },
                            ),
                          ),
                        )
                        .toList(),
            ),
          );
        },
      ),
    );
  }
}
