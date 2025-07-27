import 'package:flutter/material.dart';
import 'package:planner/widgets/custom_scrollable.dart';
import 'package:planner/widgets/gender_switch.dart';

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
                  labelText: 'Height (cm)',
                  controller: heightController,
                ),
                CustomScrollable(
                  labelText: 'Weight (kg)',
                  controller: weightController,
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                double height = double.tryParse(heightController.text) ?? 0;
                double weight = double.tryParse(weightController.text) ?? 0;
                height = height / 100; // Convert height to meters
                double bmi = weight / (height * height);
                setState(() {
                  result = bmi;
                });
              },
              child: const Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
            Text(
              'Your BMI is: ${result.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _textResult(result),
              style: const TextStyle(fontSize: 22,),
            ),
          ],
        ),
      ),
    );
  }
}
