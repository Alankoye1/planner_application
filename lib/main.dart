import 'package:flutter/material.dart';
import 'package:planner/providers/exercise_provider.dart';
import 'package:planner/providers/font_provider.dart';
import 'package:planner/providers/theme_provider.dart';
import 'package:planner/providers/user_provider.dart';
import 'package:planner/screens/auth_screen.dart';
import 'package:planner/screens/tab_screen.dart';
import 'package:planner/providers/custom_exercise_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
// TODO: Implement data persistence (e.g., local storage, cloud)
// TODO: Add Animations for transitions

void main() async {
  // Ensure Flutter is initialized before accessing platform features
  WidgetsFlutterBinding.ensureInitialized();

  // Lock device orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize the theme provider (without waiting)
  final themeProvider = ThemeProvider();
  final fontProvider = FontProvider();

  // Start the app without waiting for theme to load
  // The theme will be applied once loaded
  runApp(MyApp(themeProvider: themeProvider, fontProvider: fontProvider));

  // Initialize theme in the background
  themeProvider.initializeTheme();
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final FontProvider fontProvider;

  const MyApp({
    super.key,
    required this.themeProvider,
    required this.fontProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CustomExerciseProvider()),
        ChangeNotifierProvider.value(value: ExerciseProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: fontProvider),
        ChangeNotifierProvider.value(value: UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => Consumer<FontProvider>(
          builder: (context, fontProvider, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.deepOrange,
              colorScheme: ColorScheme.light(
                primary: Colors.deepOrange,
                secondary: Colors.orangeAccent,
              ),
              textTheme: Typography.material2021().black.copyWith(
                bodyLarge: TextStyle(fontSize: fontProvider.fontSize),
                bodyMedium: TextStyle(fontSize: fontProvider.fontSize),
                titleMedium: TextStyle(fontSize: fontProvider.fontSize + 2),
                titleLarge: TextStyle(fontSize: fontProvider.fontSize + 4),
                headlineSmall: TextStyle(fontSize: fontProvider.fontSize + 6),
                headlineMedium: TextStyle(fontSize: fontProvider.fontSize + 8),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.dark(
                primary: Colors.blue.shade700,
                secondary: Colors.blueAccent,
              ),
              textTheme: Typography.material2021().white.copyWith(
                bodyLarge: TextStyle(fontSize: fontProvider.fontSize),
                bodyMedium: TextStyle(fontSize: fontProvider.fontSize),
                titleMedium: TextStyle(fontSize: fontProvider.fontSize + 2),
                titleLarge: TextStyle(fontSize: fontProvider.fontSize + 4),
                headlineSmall: TextStyle(fontSize: fontProvider.fontSize + 6),
                headlineMedium: TextStyle(fontSize: fontProvider.fontSize + 8),
                headlineLarge: TextStyle(fontSize: fontProvider.fontSize + 10),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blueGrey.shade900,
                foregroundColor: Colors.white,
              ),
              useMaterial3: true,
            ),
            themeMode: themeProvider.themeMode,
            home: HomeWrapper(),
          ),
        ),
      ),
    );
  }
}

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final customExerciseProvider = Provider.of<CustomExerciseProvider>(context, listen: false);
    
    await userProvider.autoLogin();
    
    // Load custom exercises if user is logged in
    if (userProvider.currentUser != null && 
        userProvider.currentUser!.id != null && 
        userProvider.currentUser!.token != null) {
      await customExerciseProvider.fetchAndSetCustom(
        userProvider.currentUser!.id!, 
        userProvider.currentUser!.token!
      );
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.currentUser != null) {
          return TabScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
