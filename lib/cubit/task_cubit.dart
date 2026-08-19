import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskat_app/services/firebase_services.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final FirebaseServicee firebaseService;

  TaskCubit(this.firebaseService) : super(TaskInitial());

  // GET
  Future<void> getTasks() async {
    try {
      emit(TaskLoading());

      final tasks = await firebaseService.getTasks();
      print(tasks);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // ADD
  Future<void> addTask(Map<String, dynamic> data) async {
    try {
      emit(TaskLoading());

      await firebaseService.addTask(data);

      final tasks = await firebaseService.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // UPDATE
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      emit(TaskLoading());

      await firebaseService.updateTask(taskId, data);

      final tasks = await firebaseService.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  // DELETE
  Future<void> deleteTask(String taskId) async {
    try {
      emit(TaskLoading());

      await firebaseService.deleteTask(taskId);
      
      final tasks = await firebaseService.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
