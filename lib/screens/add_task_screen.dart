import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskBloc taskBloc; // додали

  const AddTaskScreen({Key? key, required this.taskBloc}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = "Low";
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) => value!.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ["Low", "Medium", "High"]
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: const InputDecoration(labelText: "Priority"),
              ),
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
                    widget.taskBloc.add(AddTaskEvent(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _priority,
                      dueDate: _dueDate,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add Task"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
