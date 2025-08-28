import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';
import 'package:planner/config/app_config.dart';
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
            '${AppConfig.realtimeDbBase}/users/${currentUser?.id}/customExercises/$categoryName.json?auth=${currentUser!.token}';
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
      '${AppConfig.realtimeDbBase}/users/$id/customExercises.json?auth=$token';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody == 'null' || responseBody.isEmpty) {
          customExercises.clear();
          notifyListeners();
          return;
        }

        final data = json.decode(responseBody) as Map<String, dynamic>;
        customExercises.clear();

        data.forEach((categoryName, value) {
          // If you save as: {categoryName: [exercise, exercise, ...]}
          if (value is List) {
            customExercises[categoryName] = value
                .map((item) => Excercise.fromJson(item as Map<String, dynamic>))
                .toList();
          }
          // If you save as: {categoryName: {exercises: [...]}
          else if (value is Map<String, dynamic> &&
              value['exercises'] is List) {
            customExercises[categoryName] = (value['exercises'] as List)
                .map((item) => Excercise.fromJson(item as Map<String, dynamic>))
                .toList();
          } else {
            customExercises[categoryName] = [];
          }
        });

        notifyListeners();
      } else {
      }
    } catch (e) {
      throw Exception('Error fetching custom exercises: $e');
    }
  }

  void deleteCustom(String category, BuildContext context) async {
    customExercises.remove(category);
    final currentUser = Provider.of<UserProvider>(
      context,
      listen: false,
    ).currentUser;
  final url =
    '${AppConfig.realtimeDbBase}/users/${currentUser?.id}/customExercises/$category.json?auth=${currentUser!.token}';
    await http.delete(Uri.parse(url));
    if (context.mounted) {
      notifyListeners();
    }
  }

  void addExcerciseToCustom(
    BuildContext context,
    String category,
    List<Excercise> exercises,
  ) {
    final currentUser = Provider.of<UserProvider>(
      context,
      listen: false,
    ).currentUser;
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
                        : () async {
                            customExercises[category]!.add(exercise);
              final url =
                '${AppConfig.realtimeDbBase}/users/${currentUser?.id}/customExercises/$category.json?auth=${currentUser!.token}';
                            await http.put(
                              Uri.parse(url),
                              body: json.encode({
                                'categoryName': category,
                                'exercises': customExercises[category]!
                                    .map((e) => e.toJson())
                                    .toList(),
                              }),
                            );
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
                            updateExerciseInCustom(
                              category: category,
                              updatedExercise: exercise,
                              context: context,
                            );
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

  Future<void> deleteExerciseFromCustom(
    Excercise exercise,
    String category,
    BuildContext context,
  ) async {
    final currentUser = Provider.of<UserProvider>(
      context,
      listen: false,
    ).currentUser;

    // Remove the exercise locally
    customExercises[category]?.removeWhere(
      (existingExercise) => existingExercise.id == exercise.id,
    );

    // Update the exercises array in Firebase
  final url =
    '${AppConfig.realtimeDbBase}/users/${currentUser?.id}/customExercises/$category/exercises.json?auth=${currentUser!.token}';

    await http.put(
      Uri.parse(url),
      body: json.encode(
        customExercises[category]!.map((e) => e.toJson()).toList(),
      ),
    );

    if (context.mounted) {
      notifyListeners(); // Notify widgets to rebuild
    }
  }

  Future<void> updateExerciseInCustom({
    required String category,
    required Excercise updatedExercise,
    required BuildContext context,
  }) async {
    final currentUser = Provider.of<UserProvider>(
      context,
      listen: false,
    ).currentUser;

    // Find index of the exercise to update
    final index = customExercises[category]?.indexWhere(
      (e) => e.id == updatedExercise.id,
    );

    if (index != null && index != -1) {
      // Update locally
      customExercises[category]![index] = updatedExercise;

      // Update in Firebase (update the whole exercises array for the category)
    final url =
      '${AppConfig.realtimeDbBase}/users/${currentUser?.id}/customExercises/$category/exercises.json?auth=${currentUser!.token}';

      await http.put(
        Uri.parse(url),
        body: json.encode(
          customExercises[category]!.map((e) => e.toJson()).toList(),
        ),
      );

      if (context.mounted) {
        notifyListeners();
      }
    }
  }
}
