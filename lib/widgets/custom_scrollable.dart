import 'package:flutter/material.dart';

class CustomScrollable extends StatefulWidget {
  const CustomScrollable({
    super.key,
    required this.labelText,
    required this.controller,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    this.step = 1,
  });

  final String labelText;
  final TextEditingController controller;
  final int minValue;
  final int maxValue;
  final int initialValue;
  final int step;

  @override
  State<CustomScrollable> createState() => _CustomScrollableState();
}

class _CustomScrollableState extends State<CustomScrollable> {
  late FixedExtentScrollController scrollController;
  late int currentValue;
  late List<int> values;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Generate values list based on min, max, and step
    values = [];
    for (int i = widget.minValue; i <= widget.maxValue; i += widget.step) {
      values.add(i);
    }

    // Find initial index
    currentValue = widget.initialValue;
    selectedIndex = values.indexOf(currentValue);
    if (selectedIndex == -1) {
      selectedIndex = 0;
      currentValue = values[0];
    }

    scrollController = FixedExtentScrollController(initialItem: selectedIndex);
    widget.controller.text = currentValue.toString();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  // Scrollable picker
                  SizedBox(
                    height: 120,
                    child: ListWheelScrollView(
                      controller: scrollController,
                      itemExtent: 40,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          selectedIndex = index;
                          currentValue = values[index];
                          widget.controller.text = currentValue.toString();
                        });
                      },
                      children: values.map((value) {
                        return Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Selection indicator
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.5),
                              width: 2,
                            ),
                            color: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
