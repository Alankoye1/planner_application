import 'package:flutter/material.dart';
import 'package:planner/screens/bmi_screen.dart';
import 'package:planner/screens/favorite_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BmiScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Calory Tracker'),
            onTap: () {
              // TODO: Navigate to calory tracker screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FavoriteScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
    );
  }
}
