import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planner/data.dart';
import 'package:planner/config/app_config.dart';
import 'package:planner/providers/user_provider.dart';

class ExerciseProvider with ChangeNotifier {
  bool isFavorite(String id) {
    final exercise = allExercises.firstWhere((exercise) => exercise.id == id);
    return exercise.isFavorite ?? false;
  }

  Future<void> fetchAndSetFavorite(String userId, String token) async {
    final url =
        '${AppConfig.realtimeDbBase}/users/$userId/favoriteExercises.json?auth=$token';
    
    try {
      print('Fetching favorites from: $url'); // Debug log
      
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Handle null or empty response
        if (data == null) {
          print('No favorite exercises found for user');
          notifyListeners();
          return;
        }
        
        // Handle different data structures
        if (data is Map<String, dynamic>) {
          if (data.containsKey('exercises') && data['exercises'] != null) {
            // Handle nested structure: data['exercises']
            final exercises = data['exercises'] as Map<String, dynamic>;
            _updateFavoriteExercises(exercises);
          } else {
            // Handle flat structure: data is directly the exercises map
            _updateFavoriteExercises(data);
          }
        }
        
        notifyListeners();
      } else if (response.statusCode == 404) {
        // User has no favorite exercises yet - this is normal
        print('No favorite exercises found (404) - this is normal for new users');
        notifyListeners();
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load favorite exercises: HTTP ${response.statusCode}');
      }
    } catch (error) {
      print('Error in fetchAndSetFavorite: $error'); // Debug log
      if (error is FormatException) {
        throw Exception('Error parsing favorite exercises data: Invalid JSON format');
      } else {
        throw Exception('Error fetching favorite exercises: $error');
      }
    }
  }

  // Helper method to update favorite exercises
  void _updateFavoriteExercises(Map<String, dynamic> exercises) {
    exercises.forEach((key, fav) {
      if (fav is Map<String, dynamic>) {
        final exerciseId = fav['id'] ?? key;
        final isFavorite = fav['isFavorite'] ?? false;
        
        final index = allExercises.indexWhere((e) => e.id == exerciseId);
        if (index != -1) {
          allExercises[index].isFavorite = isFavorite;
        }
      }
    });
  }

  List get favoriteExercises {
    return allExercises
        .where((exercise) => exercise.isFavorite ?? false)
        .toList();
  }

  void toggleFavorite(String id, UserProvider userProvider) {
  final url =
    '${AppConfig.realtimeDbBase}/users/${userProvider.currentUser?.id}/favoriteExercises/exercises/$id.json?auth=${userProvider.currentUser?.token}';
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
