import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';
import 'package:planner/providers/user_provider.dart';
import 'package:planner/screens/excercise_detail_screen.dart';
import 'package:provider/provider.dart';

class CustomExerciseProvider extends ChangeNotifier {
  // Method to add a new custom exercise category
  Future<void> addingCustom(BuildContext context) async {
    final TextEditingController name = TextEditingController();
    final currentUser = Provider.of<UserProvider>(
      context,
      listen: false,
    ).currentUser;
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
              onPressed: () async {
                final categoryName = name.text.trim();
                if (categoryName.isNotEmpty) {
                  customExercises[categoryName] = <Excercise>[];
                  final url =
                    'https://fit-planner-de29a-default-rtdb.firebaseio.com/users/${currentUser?.id}/customExercises/$categoryName.json?auth=${currentUser!.token}';
                  await http.post(
                    Uri.parse(url),
                    body: json.encode({
                      'categoryName': categoryName,
                    }), // empty list for new category
                  );
                  notifyListeners();
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

  Future<void> fetchAndSetCustom(String id, String token) async {
    try {
      final url =
          'https://fit-planner-de29a-default-rtdb.firebaseio.com/users/$id/customExercises.json?auth=$token';

      print('Fetching custom exercises from: $url');

      final response = await http.get(Uri.parse(url));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody == 'null' || responseBody.isEmpty) {
          print('No custom exercises found');
          customExercises.clear();
          notifyListeners();
          return;
        }

        final data = json.decode(responseBody, reviver: (key, value) {
          if (key == 'categoryName') {
            print('Category name: $value');
          }
          return value;
        }) as Map<String, dynamic>;
        customExercises.clear();

        data.forEach((categoryName, exerciseList) {
            print('Category name: $categoryName');
          if (exerciseList != null && exerciseList is List) {
            customExercises[categoryName] = exerciseList
                .map((item) => Excercise.fromJson(item as Map<String, dynamic>))
                .toList();
          } else {
            customExercises[categoryName] = [];
          }
        });

        print('Loaded custom exercises: ${customExercises.keys.toList()}');
        notifyListeners();
      } else {
        print(
          'Failed to fetch custom exercises. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching custom exercises: $e');
    }
  }

  void deleteCustom(String category) {
    customExercises.remove(category);
    notifyListeners();
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
                            id: exercise.id,
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
                            id: exercise.id,
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
    customExercises[category]?.removeWhere(
      (existingExercise) => existingExercise.id == exercise.id,
    );
    notifyListeners(); // Notify widgets to rebuild
  }
}
