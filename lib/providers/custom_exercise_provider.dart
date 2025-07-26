import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';
import 'package:planner/screens/excercise_detail_screen.dart';

class CustomExerciseProvider extends ChangeNotifier {
  // Method to add a new custom exercise category
  Future<void> addingExercise(BuildContext context) async {
    final TextEditingController name = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Custom Exercise'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Name of Custom'),
            controller: name,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.text.trim().isNotEmpty) {
                  customExercises[name.text.trim()] = <Excercise>[];
                  notifyListeners(); // Notify widgets to rebuild
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addExcerciseToCustom(
    BuildContext context,
    String category,
    List<Excercise> exercises,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exercise to Custom'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: allExercises.map((exercise) {
                // Check if exercise is already in the custom category
                bool isAlreadyAdded =
                    customExercises[category]?.any(
                      (existingExercise) => existingExercise.id == exercise.id,
                    ) ??
                    false;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(exercise.excerciseImage),
                  ),
                  title: Text(exercise.excerciseTitle),
                  trailing: IconButton(
                    onPressed: isAlreadyAdded
                        ? null
                        : () {
                            customExercises[category]!.add(exercise);
                            notifyListeners();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                    icon: Icon(
                      isAlreadyAdded ? Icons.check : Icons.add,
                      color: isAlreadyAdded ? Colors.grey : Colors.green,
                    ),
                  ),
                  onTap: () {
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailScreen(
                            imageUrl: exercise.excerciseImage,
                            title: exercise.excerciseTitle,
                          ),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void editExerciseInCustom(
    BuildContext context,
    String category,
    List<Excercise> exercises,
    Excercise removeExercise,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exercise to Custom'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: allExercises.map((exercise) {
                // Check if exercise is already in the custom category
                bool isAlreadyAdded =
                    customExercises[category]?.any(
                      (existingExercise) => existingExercise.id == exercise.id,
                    ) ??
                    false;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(exercise.excerciseImage),
                  ),
                  title: Text(exercise.excerciseTitle),
                  trailing: IconButton(
                    onPressed: isAlreadyAdded
                        ? null
                        : () {
                            customExercises[category]!.remove(removeExercise);
                            customExercises[category]!.add(exercise);
                            notifyListeners();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                    icon: Icon(
                      isAlreadyAdded ? Icons.check : Icons.change_circle,
                      color: isAlreadyAdded ? Colors.grey : Colors.green,
                    ),
                  ),
                  onTap: () {
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailScreen(
                            imageUrl: exercise.excerciseImage,
                            title: exercise.excerciseTitle,
                          ),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void deleteExerciseFromCustom(Excercise exercise, String category) {
    customExercises[category]?.removeWhere((existingExercise) => existingExercise.id == exercise.id);
    notifyListeners(); // Notify widgets to rebuild
  }
}
