import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/widgets/category_item.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryItem(
            categoryId: categories[index].id,
            categoryImage: categories[index].categoryImage,
            categoryTitle: categories[index].categoryTitle,
            categoryexcerciseCount: categories[index].excercises.length
                .toString(),
          );
        },
      ),
    );
  }
}
