import 'package:flutter/material.dart';
import 'package:planner/data.dart';

class ExerciseProvider with ChangeNotifier {
  bool isFavorite(String id) {
    final exercise = allExercises.firstWhere((exercise) => exercise.id == id);
    return exercise.isFavorite ?? false;
  }

  List get favoriteExercises {
    return allExercises
        .where((exercise) => exercise.isFavorite ?? false)
        .toList();
  }

  void toggleFavorite(String id) {
    final index = allExercises.indexWhere((exercise) => exercise.id == id);
    allExercises[index].isFavorite = !(allExercises[index].isFavorite ?? false);
    notifyListeners();
  }
}
