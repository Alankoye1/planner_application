import 'package:flutter/material.dart';
import 'package:planner/providers/exercise_provider.dart';
import 'package:planner/screens/excercise_detail_screen.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final favoriteExercises = exerciseProvider.favoriteExercises;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: favoriteExercises.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorite exercises yet',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                final exercise = favoriteExercises[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(
                          imageUrl: exercise.excerciseImage,
                          title: exercise.excerciseTitle,
                          id: exercise.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: Theme.of(context).brightness == Brightness.light ? 3 : 6,
                    shadowColor: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(exercise.excerciseImage),
                      ),
                      title: Text(exercise.excerciseTitle),
                      trailing: IconButton(
                        onPressed: () {
                          exerciseProvider.toggleFavorite(exercise.id);
                        },
                        icon: const Icon(Icons.favorite, color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
              itemCount: favoriteExercises.length,
            ),
    );
  }
}
