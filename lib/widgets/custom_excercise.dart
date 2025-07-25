import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';
import 'package:planner/providers/custom_exercise_provider.dart';
import 'package:provider/provider.dart';

class CustomExercise extends StatelessWidget {
  const CustomExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomExerciseProvider>(
      builder: (context, provider, child) {
        return customExercises.isEmpty
            ? Center(
                child: InkWell(
                  onTap: () {
                    provider.addingExercise(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: customExercises.length,
                itemBuilder: (context, index) {
                  String category = customExercises.keys.elementAt(index);
                  List<Excercise> exercises = customExercises[category]!;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 2,
                    child: ExpansionTile(
                      title: Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
                            onPressed: () {
                              // TODO: Implement adding exercise to category
                            },
                          ),
                          const Icon(Icons.expand_more),
                        ],
                      ),
                      children: exercises.map((exercise) {
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              exercise.excerciseImage,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            exercise.excerciseTitle,
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              // TODO: Implement edit functionality
                            },
                          ),
                          onTap: () {
                            // TODO: Implement exercise details or actions
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
      },
    );
  }
}
