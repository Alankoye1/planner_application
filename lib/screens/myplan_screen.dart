import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/widgets/custom_excercise.dart';
import 'package:planner/widgets/schedule.dart';
import 'package:planner/widgets/navigation_screen.dart';
import 'package:planner/providers/custom_exercise_provider.dart';
import 'package:provider/provider.dart';

class MyplanScreen extends StatefulWidget {
  const MyplanScreen({super.key});

  @override
  State<MyplanScreen> createState() => _MyplanScreenState();
}

class _MyplanScreenState extends State<MyplanScreen> with TickerProviderStateMixin {
  bool _isSchedule = true;
  CustomExerciseProvider? _provider;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_provider == null) {
      _provider = Provider.of<CustomExerciseProvider>(context, listen: false);
      _provider!.addListener(_updateUI);
    }
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_updateUI);
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Fitness Plan',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1D29),
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track your progress and customize workouts',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF64748B),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Navigation Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: NavigationScreen(
                onToggle: (isSchedule) {
                  setState(() {
                    _isSchedule = isSchedule;
                  });
                  _fadeController.reset();
                  _fadeController.forward();
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Content with animation
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(_isSchedule),
                    child: _isSchedule ? const Schedule() : const CustomExercise(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_isSchedule && customExercises.isNotEmpty
          ? Consumer<CustomExerciseProvider>(
              builder: (context, provider, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withValues(alpha:0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      provider.addingCustom(context);
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
