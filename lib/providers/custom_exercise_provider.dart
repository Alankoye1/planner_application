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
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addExcerciseToCustom(BuildContext context, String category) {
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
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(exercise.excerciseImage),
                  ),
                  title: Text(exercise.excerciseTitle),
                  trailing: IconButton(
                    onPressed: () {
                      customExercises['$category']!.add(exercise);
                      notifyListeners();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(
                          imageUrl: exercise.excerciseImage,
                          title: exercise.excerciseTitle,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
