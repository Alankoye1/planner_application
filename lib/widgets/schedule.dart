import 'package:flutter/material.dart';
import 'package:planner/data.dart';
import 'package:planner/models/excersice.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> with TickerProviderStateMixin {
  final Map<String, bool> _completionStatus = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Helper method to create a unique key for each exercise based on day and ID
  String _getExerciseKey(String day, String exerciseId) {
    return '$day-$exerciseId';
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Calculate completion percentage for a day
  double _getDayProgress(String day, List<Excercise> exercises) {
    if (exercises.isEmpty) return 1.0;
    int completed = 0;
    for (var exercise in exercises) {
      if (_completionStatus[_getExerciseKey(day, exercise.id)] == true) {
        completed++;
      }
    }
    return completed / exercises.length;
  }

  // Get gradient colors based on day completion
  List<Color> _getDayGradient(double progress, ColorScheme colorScheme) {
    if (progress == 1.0) {
      return [colorScheme.primary, colorScheme.secondary]; // Primary gradient for complete
    } else if (progress > 0.5) {
      return [colorScheme.tertiary, colorScheme.tertiaryContainer]; // Tertiary gradient for partial
    } else if (progress > 0) {
      return [colorScheme.secondary, colorScheme.secondaryContainer]; // Secondary gradient for started
    } else {
      return [colorScheme.outline, colorScheme.outlineVariant]; // Outline gradient for not started
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: scheduledExercises.keys.length,
              itemBuilder: (context, index) {
                String day = scheduledExercises.keys.elementAt(index);
                List<Excercise> exercises = scheduledExercises[day]!;
                double progress = _getDayProgress(day, exercises);
                List<Color> gradientColors = _getDayGradient(progress, colorScheme);
                
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColors[0].withValues(alpha:0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.all(20),
                              childrenPadding: const EdgeInsets.only(bottom: 16),
                              title: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: colorScheme.onPrimary.withValues(alpha:0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        day.substring(0, 3).toUpperCase(),
                                        style: TextStyle(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          day,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          exercises.isEmpty 
                                            ? 'Rest Day' 
                                            : '${exercises.length} exercises',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onPrimary.withValues(alpha:0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (exercises.isNotEmpty) ...[
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: colorScheme.onPrimary.withValues(alpha:0.2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: CircularProgressIndicator(
                                        value: progress,
                                        backgroundColor: colorScheme.onPrimary.withValues(alpha:0.3),
                                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(progress * 100).round()}%',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              children: exercises.isEmpty
                                  ? [
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: colorScheme.onPrimary.withValues(alpha:0.2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.spa,
                                              color: colorScheme.onPrimary.withValues(alpha:0.8),
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Take a well-deserved rest',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorScheme.onPrimary.withValues(alpha:0.8),
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                  : exercises
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) {
                                          int exerciseIndex = entry.key;
                                          Excercise exercise = entry.value;
                                          bool isCompleted = _completionStatus[_getExerciseKey(day, exercise.id)] ?? false;
                                          
                                          return TweenAnimationBuilder<double>(
                                            duration: Duration(milliseconds: 200 + (exerciseIndex * 50)),
                                            tween: Tween(begin: 0.0, end: 1.0),
                                            builder: (context, animValue, child) {
                                              return Transform.translate(
                                                offset: Offset(0, 10 * (1 - animValue)),
                                                child: Opacity(
                                                  opacity: animValue.clamp(0.0, 1.0),
                                                  child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withValues(alpha:isCompleted ? 0.3 : 0.2),
                                                      borderRadius: BorderRadius.circular(15),
                                                      border: Border.all(
                                                        color: Colors.white.withValues(alpha:0.3),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                      leading: Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(25),
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(23),
                                                          child: Image.asset(
                                                            exercise.excerciseImage,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        exercise.excerciseTitle,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          decoration: isCompleted 
                                                            ? TextDecoration.lineThrough 
                                                            : TextDecoration.none,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        isCompleted ? 'Completed!' : 'Tap to mark complete',
                                                        style: TextStyle(
                                                          color: Colors.white.withValues(alpha:0.7),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      trailing: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _completionStatus[_getExerciseKey(day, exercise.id)] = !isCompleted;
                                                          });
                                                        },
                                                        child: AnimatedContainer(
                                                          duration: const Duration(milliseconds: 200),
                                                          width: 28,
                                                          height: 28,
                                                          decoration: BoxDecoration(
                                                            color: isCompleted 
                                                              ? Colors.white 
                                                              : Colors.transparent,
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              width: 2,
                                                            ),
                                                            borderRadius: BorderRadius.circular(14),
                                                          ),
                                                          child: isCompleted
                                                            ? Icon(
                                                                Icons.check,
                                                                color: gradientColors[0],
                                                                size: 18,
                                                              )
                                                            : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                      .toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
  }
}
