import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;

  const AddTaskEvent({
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
  });

  @override
  List<Object?> get props => [title, description, priority, dueDate];
}

class UpdateTaskEvent extends TaskEvent {
  final String id;
  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;

  const UpdateTaskEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
  });

  @override
  List<Object?> get props => [id, title, description, priority, dueDate];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;

  const DeleteTaskEvent(this.id);

  @override
  List<Object?> get props => [id];
}
