import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../models/task_item.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _priority = "Low";
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    final taskState = context.read<TaskBloc>().state;
    TaskItem? task;
    if (taskState is TaskLoaded) {
      task = taskState.tasks.firstWhere(
            (t) => t.id == widget.taskId,
        orElse: () => TaskItem(
          id: '',
          title: '',
          description: '',
          priority: 'Low',
          dueDate: null,
        ),
      );
    }
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _priority = task?.priority ?? "Low";
    _dueDate = task?.dueDate?.toDate(); // Timestamp? -> DateTime?
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) => value!.isEmpty ? "Enter a title" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ["Low", "Medium", "High"]
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: const InputDecoration(labelText: "Priority"),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? "Select due date"
                          : _dueDate!.toLocal().toString().split(' ')[0],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) setState(() => _dueDate = date);
                    },
                    child: const Text("Pick Date"),
                  )
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<TaskBloc>().add(UpdateTaskEvent(
                      id: widget.taskId,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _priority,
                      dueDate: _dueDate, // DateTime? для Bloc
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
