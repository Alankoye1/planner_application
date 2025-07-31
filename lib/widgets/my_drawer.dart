import 'package:flutter/material.dart';
import 'package:planner/screens/bmi_screen.dart';
import 'package:planner/screens/calory_calculate_screen.dart';
import 'package:planner/screens/favorite_screen.dart';
import 'package:planner/screens/settings/screens/setting_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.orange,
                  child: Icon(Icons.person, size: 50, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('BMI Calculator'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BmiScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Calory Tracker'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CaloryCalculateScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
