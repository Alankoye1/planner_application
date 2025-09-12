import 'package:flutter/material.dart';
import 'package:planner/screens/excersice_screen.dart';

class ModernCategoryCard extends StatelessWidget {
  final dynamic category;
  final int index;
  final ColorScheme colorScheme;

  const ModernCategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    // Create theme-aware color pairs
    final colors = [
      [colorScheme.primary, colorScheme.secondary],
      [colorScheme.secondary, colorScheme.tertiary],
      [colorScheme.primary, colorScheme.tertiary],
      [colorScheme.secondary, colorScheme.primary],
      [colorScheme.tertiary, colorScheme.secondary],
      [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)],
    ];

    final colorPair = colors[index % colors.length];

    return GestureDetector(
      onTap: () {
        // Navigate to exercises screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Excercisescreen(categoryTitle: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colorPair,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorPair[0].withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              // Navigate to exercises screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Excercisescreen(categoryTitle: category.categoryTitle),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        category.categoryImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 28,
                          );
                        },
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Title
                  Text(
                    category.categoryTitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Exercise count
                  Text(
                    '${category.excercises.length} exercises',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Arrow icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
