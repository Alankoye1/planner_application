import 'package:flutter/material.dart';

class ExcerciseItem extends StatelessWidget {
  const ExcerciseItem({super.key, required this.imageUrl, required this.title,});
  final String imageUrl;
  final String title;


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
          icon: const Icon(Icons.play_circle_fill, color: Colors.red, size: 24),
          onPressed: () {
            // TODO: Implement play functionality
          },
        ),
      ), child: Image.asset(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
