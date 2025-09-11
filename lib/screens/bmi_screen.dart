import 'package:flutter/material.dart';
import 'package:planner/widgets/custom_scrollable.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> with TickerProviderStateMixin {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isMale = true;
  double result = 0.0;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  String _textResult(double bmi) {
    if (bmi < 18.5) {
      return 'You are Underweight';
    } else if (bmi < 25) {
      return 'You are Normal weight';
    } else if (bmi < 30) {
      return 'You are Overweight';
    } else {
      return 'You are Obese';
    }
  }

  Color _getResultColor(double bmi, ColorScheme colorScheme) {
    if (bmi < 18.5) {
      return colorScheme.primary; // Blue theme color
    } else if (bmi < 25) {
      return colorScheme.secondary; // Success/normal color
    } else if (bmi < 30) {
      return colorScheme.tertiary; // Warning color
    } else {
      return colorScheme.error; // Error color
    }
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
                            'BMI Calculator',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Calculate your Body Mass Index',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: colorScheme.surface,
                              title: Text(
                                'BMI Information',
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'BMI (Body Mass Index) is a measure of body fat based on height and weight. It\'s a useful tool for screening weight categories that may lead to health problems.',
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Got it',
                                    style: TextStyle(color: colorScheme.primary),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(Icons.info_outline, color: Colors.white),
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
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Text(
                            'Calculate Your BMI',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your height and weight to get started',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Input Section
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 280,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomScrollable(
                                          labelText: 'Height (cm)',
                                          controller: heightController,
                                          minValue: 100,
                                          maxValue: 250,
                                          initialValue: 170,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: CustomScrollable(
                                          labelText: 'Weight (kg)',
                                          controller: weightController,
                                          minValue: 20,
                                          maxValue: 200,
                                          initialValue: 70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Calculate Button
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [colorScheme.primary, colorScheme.secondary],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      double height =
                                          double.tryParse(heightController.text) ?? 0;
                                      double weight =
                                          double.tryParse(weightController.text) ?? 0;
                                      height = height / 100;
                                      double bmi = weight / (height * height);
                                      setState(() {
                                        result = bmi;
                                      });
                                      _scaleController.reset();
                                      _scaleController.forward();
                                    },
                                    child: const Text(
                                      'Calculate BMI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Result Section
                          if (result > 0) ...[
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _getResultColor(
                                        result,
                                        colorScheme,
                                      ).withValues(alpha: 0.1),
                                      _getResultColor(
                                        result,
                                        colorScheme,
                                      ).withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _getResultColor(
                                      result,
                                      colorScheme,
                                    ).withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Your BMI',
                                      style: TextStyle(
                                        color: _getResultColor(result, colorScheme),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      result.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: _getResultColor(result, colorScheme),
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _textResult(result),
                                      style: TextStyle(
                                        color: _getResultColor(result, colorScheme),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],

                          // BMI Chart
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BMI Categories',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AnimatedBuilder(
                                  animation: heightController,
                                  builder: (context, _) {
                                    final hCm = double.tryParse(heightController.text) ?? 0;
                                    final hM = hCm > 0 ? hCm / 100 : 0;
                                    double wForBmi(double bmi) =>
                                        hM == 0 ? 0 : bmi * hM * hM;

                                    final uwMax = wForBmi(18.5);
                                    final nMin = wForBmi(18.5);
                                    final nMax = wForBmi(24.9);
                                    final owMin = wForBmi(25);
                                    final owMax = wForBmi(29.9);
                                    final obMin = wForBmi(30);

                                    String kg(num v) => v == 0 ? '-' : v.toStringAsFixed(1);

                                    return _BMITable(
                                      categories: [
                                        BMICategory(
                                          'Underweight',
                                          '< 18.5',
                                          '< ${kg(uwMax)}',
                                          colorScheme.primary,
                                        ),
                                        BMICategory(
                                          'Normal',
                                          '18.5 - 24.9',
                                          '${kg(nMin)} - ${kg(nMax)}',
                                          colorScheme.secondary,
                                        ),
                                        BMICategory(
                                          'Overweight',
                                          '25 - 29.9',
                                          '${kg(owMin)} - ${kg(owMax)}',
                                          colorScheme.tertiary,
                                        ),
                                        BMICategory(
                                          'Obese',
                                          '>= 30',
                                          '>= ${kg(obMin)}',
                                          colorScheme.error,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

class BMICategory {
  final String name;
  final String bmiRange;
  final String weightRange;
  final Color color;

  BMICategory(this.name, this.bmiRange, this.weightRange, this.color);
}

class _BMITable extends StatelessWidget {
  final List<BMICategory> categories;

  const _BMITable({required this.categories});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: categories.map((category) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: category.color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: category.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: category.color,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  category.bmiRange,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  category.weightRange,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
