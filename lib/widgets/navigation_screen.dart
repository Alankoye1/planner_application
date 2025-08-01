import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key, required this.onToggle});
  final Function(bool isSchedule) onToggle;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isSchedule = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isSchedule = true;
              });
              widget.onToggle(true);
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              width: 110,
              height: 50,
              decoration: BoxDecoration(
                color: isSchedule ? Theme.of(context).colorScheme.primary : null,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Center(
                child: Text(
                  'Schedule',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSchedule
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isSchedule = false;
              });
              widget.onToggle(false);
            },
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              width: 110,
              height: 50,
              decoration: BoxDecoration(
                color: isSchedule ? null : Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  'Custom',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSchedule
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
