import 'package:flutter/material.dart';
import 'tasks_screen.dart';
import 'schedule_screen.dart';
import 'profile_screen.dart';
import '../bloc/task_bloc.dart';

class HomeScreen extends StatefulWidget {
  final TaskBloc taskBloc;

  const HomeScreen({Key? key, required this.taskBloc}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      TasksScreen(
        taskBloc: widget.taskBloc,
        onBack: () {}, // можна реалізувати навігацію назад, якщо потрібно
      ),
      ScheduleScreen(
        onBack: () {}, // реалізація кнопки назад
      ),
      ProfileScreen(
        onLogout: () {
          // реалізація виходу користувача
          print("User logged out");
        },
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
