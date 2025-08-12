import 'package:flutter/material.dart';
import 'package:planner/widgets/custom_scrollable.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isMale = true; // true for male, false for female
  double result = 0.0; // Placeholder for BMI result

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomScrollable(
                  labelText: 'Height',
                  controller: heightController,
                  minValue: 100,
                  maxValue: 250,
                  initialValue: 170,
                ),
                CustomScrollable(
                  labelText: 'Weight',
                  controller: weightController,
                  minValue: 20,
                  maxValue: 200,
                  initialValue: 70,
                ),
              ],
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Theme.of(context).colorScheme.primary,
                elevation: Theme.of(context).brightness == Brightness.light ? 1 : 5,
              ),
              onPressed: () {
                double height = double.tryParse(heightController.text) ?? 0;
                double weight = double.tryParse(weightController.text) ?? 0;
                height = height / 100; // Convert height to meters
                double bmi = weight / (height * height);
                setState(() {
                  result = bmi;
                });
              },
              child: Text('Calculate BMI', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              )),
            ),
            const SizedBox(height: 20),
            Text(
              'Your BMI is: ${result.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _textResult(result),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
