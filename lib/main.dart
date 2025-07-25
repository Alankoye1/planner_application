import 'package:flutter/material.dart';
import 'package:planner/screens/tab_screen.dart';
// TODO: Create UI for whole app
// TODO: Implement custom exercise functionality
// TODO: Responsive design for different screen sizes
// TODO: Add user authentication and profiles
// TODO: Implement data persistence (e.g., local storage, cloud)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.deepOrange,
          secondary: Colors.orangeAccent,
        ),
      ),
      home: TabScreen(),
    );
  }
}
