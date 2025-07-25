import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';

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
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Method to add exercise to a specific category
  void addExerciseToCategory(String category, Excercise exercise) {
    if (customExercises.containsKey(category)) {
      customExercises[category]!.add(exercise);
      notifyListeners();
    }
  }
}
