import 'package:flutter/material.dart';
import 'package:planner/providers/exercise_provider.dart';
import 'package:planner/screens/tab_screen.dart';
import 'package:planner/providers/custom_exercise_provider.dart';
import 'package:provider/provider.dart';
// TODO: Create UI for whole app
// TODO: Implement whole app functionality
// TODO: Responsive design for different screen sizes
// TODO: Add user authentication and profiles
// TODO: Implement data persistence (e.g., local storage, cloud)
// TODO: Add Animations for transitions

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CustomExerciseProvider()),
        ChangeNotifierProvider.value(value: ExerciseProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
