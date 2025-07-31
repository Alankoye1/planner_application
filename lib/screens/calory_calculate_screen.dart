import 'package:flutter/material.dart';
import 'package:planner/widgets/table_calory.dart';
import '../widgets/gender_switch.dart';
import '../widgets/custom_scrollable.dart';

class CaloryCalculateScreen extends StatefulWidget {
  const CaloryCalculateScreen({super.key});

  @override
  State<CaloryCalculateScreen> createState() => _CaloryCalculateScreenState();
}

class _CaloryCalculateScreenState extends State<CaloryCalculateScreen> {
  bool isMale = true;
  int age = 25;
  int height = 170;
  int weight = 70;
  double? result;
  String selectedActivity = 'BMR';
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
  void dispose() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calory Calculator',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gender Switch
              Center(
                child: GenderSwitch(
                  isMale: isMale,
                  onGenderChanged: (val) {
                    setState(() {
                      isMale = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Scrollables for Age, Height, Weight
              Row(
                children: [
                  CustomScrollable(
                    labelText: 'Age',
                    controller: ageController,
                    minValue: 10,
                    maxValue: 100,
                    initialValue: age,
                    step: 1,
                  ),
                  CustomScrollable(
                    labelText: 'Height (cm)',
                    controller: heightController,
                    minValue: 100,
                    maxValue: 220,
                    initialValue: height,
                    step: 1,
                  ),
                  CustomScrollable(
                    labelText: 'Weight (kg)',
                    controller: weightController,
                    minValue: 30,
                    maxValue: 200,
                    initialValue: weight,
                    step: 1,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Activity Level Dropdown
              Row(
                children: [
                  Text(
                    'Activity Level:',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedActivity,
                      isExpanded: true,
                      items: activityMultipliers.keys.map((level) {
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: calculateCalory,
                style: ElevatedButton.styleFrom(
                  shadowColor: Theme.of(context).colorScheme.primary,
                  elevation: Theme.of(context).brightness == Brightness.light
                      ? 1
                      : 5,
                ),
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 32),
              // padding: const EdgeInsets.symmetric(vertical: 16),
              // textStyle: Theme.of(context).textTheme.headlineSmall,
              if (result != null && caloryTable != null)
                Column(
                  children: [
                    Text(
                      'Your daily calorie need:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${result!.toStringAsFixed(0)} kcal',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 32),
                    // Calorie Table
                    TableCalory(caloryTable: caloryTable, result: result!),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
