import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_tutorial/app/data/models/task_model.dart';

class HomeController extends GetxController with StateMixin<List<TaskModel>?> {
  final todoList = <TaskModel>[].obs;
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
      todoList.clear();
      todoList.addAll(_boxTask.toMap().values.toList());
      change(todoList, status: RxStatus.success());
    }
  }

  Future<void> addTask({required String title, String? description, String? tag, required bool done}) async {
    int id = DateTime.now().millisecond;
    final _task = TaskModel(id: id, title: title, description: description ?? '', tag: tag ?? '', done: done);
    todoList.add(_task);
    await _boxTask.add(_task);
    change(todoList, status: RxStatus.success());
  }

  void changeStatus(int index, bool newValue) async {
    todoList[index].done = newValue;
    await todoList[index].save();
    change(todoList, status: RxStatus.success());
  }

  Future<void> updateTask(TaskModel? todo, {required String title, String? description, String? tag, required bool done}) async {
    int index = todoList.indexOf(todo);
    todoList[index].title = title;
    todoList[index].description = description;
    todoList[index].tag = tag;
    todoList[index].done = done;
    await todoList[index].save();
    change(todoList, status: RxStatus.success());
  }
}
