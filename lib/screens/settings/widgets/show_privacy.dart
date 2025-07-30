import 'package:flutter/material.dart';

class ShowPrivacy extends StatelessWidget {
  const ShowPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Privacy Policy',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Last updated: July 30, 2025',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 16),
          Text(
            'This Privacy Policy describes how your personal information is collected, used, and shared when you use our Fitness Planner application.',
          ),
          SizedBox(height: 12),
          Text(
            'Information We Collect',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'We collect information you provide directly to us, such as your name, email address, and fitness goals when you create an account. We also collect data about your workout routines and progress.',
          ),
          SizedBox(height: 12),
          Text(
            'How We Use Your Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'We use the information we collect to provide, maintain, and improve our services, to develop new features, and to protect our users.',
          ),
          SizedBox(height: 12),
          Text(
            'Data Sharing',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'We do not share your personal information with third parties except as described in this privacy policy or with your consent.',
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      ),
    ],
          );
  }
}