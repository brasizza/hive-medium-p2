import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_tutorial/app/data/models/task_model.dart';

class HomeController extends GetxController with StateMixin<List<TaskModel>?> {
  final _todoList = <TaskModel>[];
  final Box<TaskModel> _boxTask = Get.find<Box<TaskModel>>();
  @override
  void onInit() {
    super.onInit();
    _buildTasks();
  }

  Future<void> _buildTasks() async {
    if (_boxTask.length == 0) {
      change(null, status: RxStatus.empty());
    } else {
      _todoList.clear();
      _todoList.addAll(_boxTask.toMap().values.toList());
      change(_todoList, status: RxStatus.success());
    }
  }

  Future<void> addTask({required String title, String? description, String? tag, required bool done}) async {
    int id = DateTime.now().millisecond;
    final _task = TaskModel(id: id, title: title, description: description ?? '', tag: tag ?? '', done: done);
    _todoList.add(_task);
    await _boxTask.add(_task);
    change(_todoList, status: RxStatus.success());
  }

  void changeStatus(int index, bool newValue) async {
    final _todo = _todoList[index];
    _todo.done = newValue;
    await _todo.save();
    change(_todoList, status: RxStatus.success());
  }

  Future<void> updateTask(TaskModel? todo, {required String title, String? description, String? tag, required bool done}) async {
    int index = _todoList.indexOf(todo!);
    final _todo = _todoList[index];
    _todo.title = title;
    _todo.description = description;
    _todo.tag = tag;
    _todo.done = done;
    await _todo.save();
    change(_todoList, status: RxStatus.success());
  }

  Future<void> deleteTask(TaskModel? todo) async {
    int index = _todoList.indexOf(todo!);
    final _todo = _todoList[index];
    await _todo.delete();
    _todoList.remove(_todo);
    if (_todoList.isEmpty) {
      change(null, status: RxStatus.empty());
    } else {
      change(_todoList, status: RxStatus.success());
    }
  }
}
