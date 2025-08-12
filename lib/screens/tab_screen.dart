import 'package:flutter/material.dart';
import 'package:planner/screens/category_screen.dart';
import 'package:planner/screens/myplan_screen.dart';
import 'package:planner/widgets/my_drawer.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>>? _pages;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'page': CategoryScreen(), 'title': 'Categories'},
      {'page': MyplanScreen(), 'title': 'My Plan'},
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: Text(
          _pages![_selectedPageIndex]['title'] as String,
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _pages![_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.white,
        selectedItemColor: theme.secondaryHeaderColor,
        currentIndex: _selectedPageIndex,
        selectedFontSize: 20,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: theme.primaryColor,
            icon: const Icon(Icons.fitness_center),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            backgroundColor: theme.primaryColor,
            icon: const Icon(Icons.playlist_add_check),
            label: 'My Plan',
          ),
        ],
      ),
    );
  }
}
