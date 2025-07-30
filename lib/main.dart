import 'package:flutter/material.dart';
import 'package:planner/providers/exercise_provider.dart';
import 'package:planner/providers/theme_provider.dart';
import 'package:planner/screens/tab_screen.dart';
import 'package:planner/providers/custom_exercise_provider.dart';
import 'package:provider/provider.dart';
// TODO: Implement whole app functionality
// TODO: Responsive design for different screen sizes
// TODO: Add user authentication and profiles
// TODO: Implement data persistence (e.g., local storage, cloud)
// TODO: Add Animations for transitions

void main() async {
  // Ensure Flutter is initialized before accessing platform features
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the theme provider (without waiting)
  final themeProvider = ThemeProvider();
  
  // Start the app without waiting for theme to load
  // The theme will be applied once loaded
  runApp(MyApp(themeProvider: themeProvider));
  
  // Initialize theme in the background
  themeProvider.initializeTheme();
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  
  const MyApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CustomExerciseProvider()),
        ChangeNotifierProvider.value(value: ExerciseProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.deepOrange,
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              secondary: Colors.orangeAccent,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: Colors.blue.shade700,
              secondary: Colors.blueAccent,
            ),
            useMaterial3: true,
          ),
          themeMode: themeProvider.themeMode,
          home: TabScreen(),
        ),
      ),
    );
  }
}
