import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planner/firebase_options.dart';
import 'package:planner/providers/exercise_provider.dart';
import 'package:planner/providers/font_provider.dart';
import 'package:planner/providers/notification_api.dart';
import 'package:planner/providers/theme_provider.dart';
import 'package:planner/providers/user_provider.dart';
import 'package:planner/screens/auth_screen.dart';
import 'package:planner/screens/tab_screen.dart';
import 'package:planner/providers/custom_exercise_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
// TODO: Add Animations for transitions

void main() async {
  // Ensure Flutter is initialized before accessing platform features
  WidgetsFlutterBinding.ensureInitialized();

  // Lock device orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationApi().initNotification();

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
        ChangeNotifierProvider(create: (_) => CustomExerciseProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => fontProvider),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
  String? _previousUserId;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen for auth state changes
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final currentUserId = userProvider.currentUser?.id;

    // Load data when user is new or changed
    if (currentUserId != null && currentUserId != _previousUserId) {
      setState(() {
        _isLoading = true; // Set loading to true when user changes
      });
      _previousUserId = currentUserId;
      _loadUserData(userProvider);
    }
  }

  Future<void> _loadUserData(UserProvider userProvider) async {
    if (userProvider.currentUser != null &&
        userProvider.currentUser!.id != null &&
        userProvider.currentUser!.token != null) {
      final customExerciseProvider = Provider.of<CustomExerciseProvider>(
        context,
        listen: false,
      );
      final exerciseProvider = Provider.of<ExerciseProvider>(
        context,
        listen: false,
      );

      try {
        await customExerciseProvider.fetchAndSetCustom(
          userProvider.currentUser!.id!,
          userProvider.currentUser!.token!,
        );
      } catch (error) {
        print('Error fetching custom exercises: $error');
        // Continue loading even if custom exercises fail
      }

      try {
        await exerciseProvider.fetchAndSetFavorite(
          userProvider.currentUser!.id!,
          userProvider.currentUser!.token!,
        );
      } catch (error) {
        print('Error fetching favorite exercises: $error');
        // Continue loading even if favorites fail
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkAutoLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.autoLogin();

    if (userProvider.currentUser == null && mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    // If user is logged in, _loadUserData will be called from didChangeDependencies
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
