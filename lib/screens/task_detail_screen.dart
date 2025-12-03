import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../models/task_item.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Details")),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            final TaskItem? task = state.tasks.firstWhere(
                  (t) => t.id == taskId,
              orElse: () => TaskItem(
                id: '',
                title: 'Not found',
                description: '',
                priority: '',
                dueDate: DateTime.now(),
              ),
            );

            if (task.id.isEmpty) {
              return const Center(child: Text("Task not found"));
            }

            return Padding(
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
                  Text("Due: ${task.dueDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit_task', arguments: task.id);
                        },
                        child: const Text("Edit"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (state is TaskError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const Center(child: Text("No tasks available"));
        },
      ),
    );
  }
}
