import 'package:flutter/material.dart';
import 'package:planner/screens/excersice_screen.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.categoryId,
    required this.categoryImage,
    required this.categoryTitle,
    required this.categoryexcerciseCount,
  });
  final String categoryId;
  final String categoryImage;
  final String categoryTitle;
  final String categoryexcerciseCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => Excercisescreen(categoryTitle: categoryTitle),));
      },
      child: Card(
        elevation: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 5,
                    color: theme.colorScheme.primary,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    categoryImage,
                    height: 80,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryTitle,
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  categoryexcerciseCount,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.navigate_next_outlined),
            SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
