import 'package:planner/models/excersice.dart';

class Category {
  final String id;
  final String categoryTitle;
  final String categoryImage;
  final List<Excercise> excercises;

  Category({
    required this.id,
    required this.categoryTitle,
    required this.categoryImage,
    required this.excercises,
  });
}
