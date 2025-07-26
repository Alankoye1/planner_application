import 'package:flutter/material.dart';
import 'package:planner/providers/exercise_provider.dart';
import 'package:provider/provider.dart';

class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.id,
  });
  final String imageUrl;
  final String title;
  final String id;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: exerciseProvider.isFavorite(widget.id)
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {
              exerciseProvider.toggleFavorite(widget.id);
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(widget.imageUrl, fit: BoxFit.fill),
      ),
    );
  }
}
