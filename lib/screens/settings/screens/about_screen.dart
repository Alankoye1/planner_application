import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Icon(Icons.info_outline, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 24),
            Text(
              'Planner App',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Version 1.0.0',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Text(
              'Planner helps you organize your workouts, track calories, and manage your fitness journey with ease.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            const Text('© 2025 Planner App'),
          ],
        ),
      ),
    );
  }
}
