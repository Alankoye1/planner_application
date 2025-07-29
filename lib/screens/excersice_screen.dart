import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/widgets/excercise_item.dart';

class Excercisescreen extends StatelessWidget {
  final String categoryTitle;

  const Excercisescreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    // Find the category that matches the categoryTitle
    final category = categories.firstWhere(
      (cat) => cat.categoryTitle == categoryTitle,
      orElse: () => categories.first, // fallback to first category if not found
    );

    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ExcerciseItem(
            imageUrl: category.excercises[index].excerciseImage,
            title: category.excercises[index].excerciseTitle,
            id: category.excercises[index].id,
            videoUrl: category.excercises[index].videoUrl,
          );
        },
        itemCount: category.excercises.length,
      ),
    );
  }
}
