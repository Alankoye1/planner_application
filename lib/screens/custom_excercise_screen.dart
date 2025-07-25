import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';

class CustomExerciseScreen extends StatelessWidget {
  const CustomExerciseScreen({super.key});

  _addingExercise(BuildContext context) {
    final TextEditingController name = TextEditingController();
    showDialog(
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

  @override
  Widget build(BuildContext context) {
    return customExercises.isEmpty
        ? Center(
            child: InkWell(
              onTap: () {
                // TODO: Implement navigation to custom exercise creation screen
                _addingExercise(context);
              },
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.add),
              ),
            ),
          )
        : ListView.builder(
            itemCount: customExercises.length,
            itemBuilder: (context, index) {
              String category = customExercises.keys.elementAt(index);
              List<Excercise> exercises = customExercises[category]!;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      // TODO: Implement add exercise to this category
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
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
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
  }
}
