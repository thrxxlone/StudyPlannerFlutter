import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';
import '../bloc/task_event.dart';
import '../models/task_item.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;
  final TaskBloc taskBloc; // додали

  const TaskDetailScreen({Key? key, required this.taskId, required this.taskBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = taskBloc.state;
    TaskItem? task;
    if (state is TaskLoaded) {
      task = state.tasks.firstWhere(
            (t) => t.id == taskId,
        orElse: () => TaskItem(
          id: '',
          title: '',
          description: '',
          priority: 'Low',
          dueDate: null,
        ),
      );
    }

    if (task == null || task.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Task Details")),
        body: const Center(child: Text("Task not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Task Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: ${task.title}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text("Description: ${task.description}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Priority: ${task.priority}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Due: ${task.dueDate?.toDate() ?? 'None'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTaskScreen(taskId: task!.id),
                      ),
                    );
                  },
                  child: const Text("Edit"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    taskBloc.add(DeleteTaskEvent(task!.id));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
