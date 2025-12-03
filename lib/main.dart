import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'bloc/task_bloc.dart';
import 'data/task_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Створюємо TaskBloc, щоб передавати в HomeScreen і TasksScreen
  final taskBloc = TaskBloc(taskRepository: TaskRepository());

  runApp(MyApp(taskBloc: taskBloc));
}

class MyApp extends StatelessWidget {
  final TaskBloc taskBloc;

  const MyApp({Key? key, required this.taskBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Builder(
        builder: (context) => LoginScreen(
          onLoginSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(taskBloc: taskBloc),
              ),
            );
          },
          onNavigateToRegister: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegisterScreen(
                  onRegisterSuccess: () {
                    // Повертаємося на LoginScreen після реєстрації
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
