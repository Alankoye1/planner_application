import 'package:flutter/material.dart';

class MyplanScreen extends StatelessWidget {
  const MyplanScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavigationScreen()
        ],
      ),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({
    super.key,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isSchedule = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            // TODO: Implement navigation to schedule screen
            setState(() {
              isSchedule = true;
            });
          },
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: 110,
            height: 50,
            decoration: BoxDecoration(
              color: isSchedule ? Colors.deepOrange : null,
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
              child: Text('Schedule',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSchedule ? Colors.white : Theme.of(context).colorScheme.primary,
                  )),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // TODO: Implement navigation to custom screen
            setState(() {
              isSchedule = false;
            });
          },
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: 110,
            height: 50,
            decoration: BoxDecoration(
              color: isSchedule ? null : Colors.deepOrange,
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
              child: Text('Custom',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSchedule ? Theme.of(context).colorScheme.primary : Colors.white,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}