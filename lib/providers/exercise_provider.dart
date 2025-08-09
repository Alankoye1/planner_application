import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planner/data.dart';
import 'package:planner/providers/user_provider.dart';

class ExerciseProvider with ChangeNotifier {
  bool isFavorite(String id) {
    final exercise = allExercises.firstWhere((exercise) => exercise.id == id);
    return exercise.isFavorite ?? false;
  }

  Future<void> fetchAndSetFavorite(String userId, String token) async {
    final url =
        'https://fit-planner-de29a-default-rtdb.firebaseio.com/users/$userId/favoriteExercises.json?auth=$token';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data structure: ${json.encode(data)}');
        if (data != null && data['exercises'] != null) {
          // Handle as Map instead of Iterable
          final exercises = data['exercises'] as Map<String, dynamic>;
          exercises.forEach((key, fav) {
            final index = allExercises.indexWhere(
                (e) => e.id == fav['id'] || e.id == key);
            if (index != -1) {
              allExercises[index].isFavorite = fav['isFavorite'] ?? false;
            }
          });
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load favorite exercises');
      }
    } catch (error) {
      print('Error fetching favorite exercises: $error');
    }
  }

  List get favoriteExercises {
    return allExercises
        .where((exercise) => exercise.isFavorite ?? false)
        .toList();
  }

  void toggleFavorite(String id, UserProvider userProvider) {
    final url =
        'https://fit-planner-de29a-default-rtdb.firebaseio.com/users/${userProvider.currentUser?.id}/favoriteExercises/exercises/$id.json?auth=${userProvider.currentUser?.token}';
    final currentFavorite =
        allExercises.firstWhere((exercise) => exercise.id == id).isFavorite ??
        false;
    http.put(
      Uri.parse(url),
      body: json.encode({'isFavorite': !currentFavorite}),
    );
    final index = allExercises.indexWhere((exercise) => exercise.id == id);
    allExercises[index].isFavorite = !(allExercises[index].isFavorite ?? false);
    notifyListeners();
  }
}
