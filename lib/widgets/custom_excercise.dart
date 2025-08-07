import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';
import 'package:planner/providers/custom_exercise_provider.dart';
import 'package:planner/screens/excercise_detail_screen.dart';
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
                    provider.addingCustom(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[400],
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
                        style:
                            Theme.of(context).textTheme.headlineMedium ??
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.expand_more),
                          const SizedBox(width: 8),
                          PopupMenuButton<int>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (int value) {
                              if (value == 0) {
                                provider.addExcerciseToCustom(
                                  context,
                                  category,
                                  exercises,
                                );
                              } else if (value == 1) {
                                provider.deleteCustom(category, context);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 0,
                                child: Text('Add Exercise'),
                              ),
                              const PopupMenuItem(
                                value: 1,
                                child: Text('Remove Category'),
                              ),
                            ],
                          ),
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          trailing: SizedBox(
                            width: 96,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    provider.editExerciseInCustom(
                                      context,
                                      category,
                                      exercises,
                                      exercise,
                                    );
                                  },
                                ),
                                // Delete button to remove the exercise
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    provider.deleteExerciseFromCustom(
                                      exercise,
                                      category,
                                      context
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ExerciseDetailScreen(
                                  imageUrl: exercise.excerciseImage,
                                  title: exercise.excerciseTitle,
                                  id: exercise.id,
                                ),
                              ),
                            );
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
