import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                CustomTextField(
                  labelText: 'Height (cm)',
                  controller: heightController,
                ),
                CustomTextField(
                  labelText: 'Weight (kg)',
                  controller: weightController,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextField(labelText: 'Age', controller: ageController),
                GenderSwitch(
                  isMale: isMale,
                  onGenderChanged: (bool value) {
                    setState(() {
                      isMale = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement BMI calculation
                double height = double.tryParse(heightController.text) ?? 0;
                double weight = double.tryParse(weightController.text) ?? 0;
                double age = double.tryParse(ageController.text) ?? 0;
                double bmi = weight / (height * height);
                setState(() {
                  if (isMale) {
                    result = ((1.2 * bmi) + (0.23 * age)) - 16.2;
                  } else {
                    result = ((1.2 * bmi) + (0.23 * age)) - 5.4;
                  }
                });
              },
              child: const Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
            Text(
              'Your BMI is: ${result.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: TextField(
        decoration: InputDecoration(labelText: labelText),
        keyboardType: TextInputType.number,
        controller: controller,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class GenderSwitch extends StatelessWidget {
  const GenderSwitch({
    super.key,
    required this.isMale,
    required this.onGenderChanged,
  });

  final bool isMale;
  final ValueChanged<bool> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isMale) {
          onGenderChanged(false);
        } else {
          onGenderChanged(true);
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.man_rounded,
            color: isMale ? Colors.blueAccent : Colors.grey,
            size: 50,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
          ),
          Icon(
            Icons.woman_rounded,
            color: isMale ? Colors.grey : Colors.pink,
            size: 50,
          ),
        ],
      ),
    );
  }
}
