import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    this.isCustomExercise = false,
  });
  final String imageUrl;
  final String title;
  final bool isCustomExercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (isCustomExercise)
            IconButton(
              icon: const Icon(Icons.add, size: 30),
              onPressed: () {
                // TODO: Implement add functionality
              },
            ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(imageUrl, fit: BoxFit.fill),
      ),
    );
  }
}
