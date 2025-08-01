import 'package:flutter/material.dart';
import 'package:planner/screens/excercise_detail_screen.dart';
import 'package:planner/screens/video_player_screen.dart';

class ExcerciseItem extends StatelessWidget {
  const ExcerciseItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.id,
    required this.videoUrl,
  });
  final String imageUrl;
  final String title;
  final String id;
  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      elevation: 4,
      shadowColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.withOpacity(0.5),
      margin: const EdgeInsets.all(12.0),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.play_circle_fill,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
                ),
              );
            },
          ),
        ),
        child: InkWell(
          child: Image.asset(imageUrl, fit: BoxFit.cover),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExerciseDetailScreen(
                  imageUrl: imageUrl,
                  title: title,
                  id: id,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
