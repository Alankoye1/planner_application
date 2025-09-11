import 'package:flutter/material.dart';
import 'package:planner/widgets/table_calory.dart';
import '../widgets/gender_switch.dart';
import '../widgets/custom_scrollable.dart';

class CaloryCalculateScreen extends StatefulWidget {
  const CaloryCalculateScreen({super.key});

  @override
  State<CaloryCalculateScreen> createState() => _CaloryCalculateScreenState();
}

class _CaloryCalculateScreenState extends State<CaloryCalculateScreen>
    with TickerProviderStateMixin {
  bool isMale = true;
  int age = 25;
  int height = 170;
  int weight = 70;
  double? result;
  String selectedActivity = 'BMR';

  late AnimationController _animationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _resultFadeAnimation;
  late Animation<Offset> _resultSlideAnimation;

  Map<String, double> activityMultipliers = {
    'BMR': 1.0,
    'Sedentary': 1.2,
    'Lightly Active': 1.375,
    'Moderately Active': 1.55,
    'Very Active': 1.725,
    'Super Active': 1.9,
  };
  Map<String, double>? caloryTable;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _resultFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _resultSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _resultAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resultAnimationController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void calculateCalory() {
    int ageVal = int.tryParse(ageController.text) ?? age;
    int heightVal = int.tryParse(heightController.text) ?? height;
    int weightVal = int.tryParse(weightController.text) ?? weight;
    double bmr;
    if (isMale) {
      bmr = 10 * weightVal + 6.25 * heightVal - 5 * ageVal + 5;
    } else {
      bmr = 10 * weightVal + 6.25 * heightVal - 5 * ageVal - 161;
    }
    Map<String, double> table = {};
    activityMultipliers.forEach((activity, multiplier) {
      table[activity] = bmr * multiplier;
    });
    setState(() {
      result = table[selectedActivity];
      caloryTable = table;
    });
    _resultAnimationController.reset();
    _resultAnimationController.forward();
  }

  _showModalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Calorie Calculator Info'),
          content: const Text(
            'This calculator estimates your daily caloric needs based on your age, gender, weight, height, and activity level.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.secondary],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Calorie Calculator',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Calculate your daily caloric needs',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.calculate, color: Colors.white),
                        onPressed: _showModalDialog,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Gender Switch Section
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.primaryContainer,
                                        colorScheme.secondaryContainer,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: GenderSwitch(
                                          isMale: isMale,
                                          onGenderChanged: (val) {
                                            setState(() {
                                              isMale = val;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          controller: ageController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Age',
                                            labelStyle: TextStyle(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                              fontSize: 14,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.all(16),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              age = int.tryParse(val) ?? age;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Height and Weight Section
                                SizedBox(
                                  height: 280,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomScrollable(
                                          labelText: 'Height',
                                          controller: heightController,
                                          minValue: 100,
                                          maxValue: 220,
                                          initialValue: height,
                                          step: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: CustomScrollable(
                                          labelText: 'Weight',
                                          controller: weightController,
                                          minValue: 20,
                                          maxValue: 200,
                                          initialValue: weight,
                                          step: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Activity Level Section
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.secondaryContainer,
                                        colorScheme.tertiaryContainer,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.fitness_center,
                                            color: colorScheme.secondary,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Activity Level',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: DropdownButton<String>(
                                          value: selectedActivity,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurface,
                                          ),
                                          items: activityMultipliers.keys.map((
                                            level,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: level,
                                              child: Text(level),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              selectedActivity = val!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Calculate Button
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.secondary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: calculateCalory,
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.calculate,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Calculate Calories',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Results Section
                                if (result != null && caloryTable != null)
                                  SlideTransition(
                                    position: _resultSlideAnimation,
                                    child: FadeTransition(
                                      opacity: _resultFadeAnimation,
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              colorScheme.secondary,
                                              colorScheme.tertiary,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: colorScheme.secondary
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.local_fire_department,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Your Daily Calorie Need',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        '${result!.toStringAsFixed(0)} kcal',
                                                        style: const TextStyle(
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 24),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: TableCalory(
                                                caloryTable: caloryTable,
                                                result: result!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
