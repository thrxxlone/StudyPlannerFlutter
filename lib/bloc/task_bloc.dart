import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/task_repository.dart';
import '../models/task_item.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskLoading()) {
    // Завантаження завдань
    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await taskRepository.getTasks();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    // Додавання завдання
    on<AddTaskEvent>((event, emit) async {
      if (state is TaskLoaded) {
        try {
          await taskRepository.addTask(TaskItem(
            id: '',
            title: event.title,
            description: event.description,
            priority: event.priority,
            dueDate: event.dueDate != null ? Timestamp.fromDate(event.dueDate!) : null,
          ));
          final tasks = await taskRepository.getTasks();
          emit(TaskLoaded(tasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      }
    });

    // Оновлення завдання
    on<UpdateTaskEvent>((event, emit) async {
      if (state is TaskLoaded) {
        try {
          await taskRepository.updateTask(TaskItem(
            id: event.id,
            title: event.title,
            description: event.description,
            priority: event.priority,
            dueDate: event.dueDate != null ? Timestamp.fromDate(event.dueDate!) : null,
          ));
          final tasks = await taskRepository.getTasks();
          emit(TaskLoaded(tasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      }
    });

    // Видалення завдання
    on<DeleteTaskEvent>((event, emit) async {
      if (state is TaskLoaded) {
        try {
          await taskRepository.deleteTask(event.id);
          final tasks = await taskRepository.getTasks();
          emit(TaskLoaded(tasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      }
    });
  }
}
