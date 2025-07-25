import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

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
                        .map(
                          (exercise) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                exercise.excerciseImage,
                              ),
                            ),
                            title: Text(exercise.excerciseTitle),
                            trailing: Checkbox(
                              value: false, // You can add state tracking here
                              onChanged: (value) {
                                // Handle exercise completion
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
