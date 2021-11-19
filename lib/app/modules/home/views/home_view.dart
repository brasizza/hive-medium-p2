import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_tutorial/app/data/models/task_model.dart';
import 'package:hive_tutorial/app/modules/home/controllers/dialog_controller.dart';
import 'package:hive_tutorial/app/modules/home/views/components/dialog_todo_widget.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Another todo project (but with Getx+ Hive)'),
        centerTitle: true,
      ),
      body: controller.obx(
        (todoList) => ListView.separated(
          itemCount: todoList!.length,
          itemBuilder: (_, index) {
            final TaskModel _todo = todoList[index];
            return ListTile(
              onTap: () {
                Get.lazyPut<DialogController>(() => DialogController());
                Get.find<DialogController>().todoCheck.value = _todo.done;
                Get.dialog(Dialog(
                  child: DialogTodo(todo: _todo),
                ));
              },
              title: Text(_todo.title),
              subtitle: Text(_todo.description ?? ''),
              leading: Checkbox(
                  value: _todo.done,
                  onChanged: (newValue) {
                    controller.changeStatus(index, newValue!);
                  }),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
        ),
        onEmpty: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('The is nothing in your task list'),
            Text('Add some taks for you!'),
          ],
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Get.lazyPut<DialogController>(() => DialogController());
          Get.dialog(Dialog(
            child: DialogTodo(),
          ));
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
