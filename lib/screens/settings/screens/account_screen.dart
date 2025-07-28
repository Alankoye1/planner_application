import 'package:flutter/material.dart';
import 'package:planner/screens/settings/widgets/custom_setting_list_tile.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  // TODO: Implement account settings functionality after Implementing data persistence and user authentication

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomSettingListTile(
            title: 'Profile',
            subtitle: 'Edit your profile information',
            icon: Icons.person,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
            iconColor: Colors.blueAccent,
          ),
          const Divider(),
          CustomSettingListTile(
            title: 'Email',
            subtitle: 'Change your email address',
            icon: Icons.email,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const EmailScreen()));
            },
            iconColor: Colors.blueAccent,
          ),
          const Divider(),
          CustomSettingListTile(
            title: 'Password',
            subtitle: 'Change your password',
            icon: Icons.lock,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const PasswordScreen()));
            },
            iconColor: Colors.blueAccent,
          ),
          const Divider(),
          CustomSettingListTile(
            title: 'Logout',
            subtitle: 'Log out of your account',
            icon: Icons.logout,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const LogoutScreen()));
            },
            iconColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email')),
      body: const Center(child: Text('Email Screen')),
    );
  }
}

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password')),
      body: const Center(child: Text('Password Screen')),
    );
  }
}

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logout')),
      body: const Center(child: Text('Logout Screen')),
    );
  }
}
