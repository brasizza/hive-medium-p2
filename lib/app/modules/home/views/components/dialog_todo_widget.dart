import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_tutorial/app/data/models/task_model.dart';
import 'package:hive_tutorial/app/modules/home/controllers/dialog_controller.dart';
import 'package:hive_tutorial/app/modules/home/controllers/home_controller.dart';

class DialogTodo extends GetView<DialogController> {
  final TaskModel? todo;
  DialogTodo({Key? key, this.todo}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController tileTextController = TextEditingController(text: (todo != null ? todo!.title : ''));
    final TextEditingController descriptionTextController = TextEditingController(text: (todo != null ? todo!.description : ''));
    final TextEditingController tagTextController = TextEditingController(text: (todo != null ? todo!.tag : ''));

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "Insert a Task!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: tileTextController,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    validator: (String? value) {
                      if (value == '') {
                        return 'A title is required';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionTextController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  TextFormField(
                    controller: tagTextController,
                    decoration: const InputDecoration(
                      labelText: 'Tag your Task with one #hashtag',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Obx(() => CheckboxListTile(
                        title: const Text('Task is done ?'),
                        value: controller.todoCheck.value,
                        onChanged: (newVal) {
                          controller.todoCheck.value = newVal!;
                        })),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          if (todo != null) {
                            Get.find<HomeController>().updateTask(
                              todo,
                              title: tileTextController.text,
                              description: descriptionTextController.text,
                              tag: tagTextController.text,
                              done: controller.todoCheck.value,
                            );
                          } else {
                            Get.find<HomeController>().addTask(
                              title: tileTextController.text,
                              description: descriptionTextController.text,
                              tag: tagTextController.text,
                              done: controller.todoCheck.value,
                            );
                          }
                          Get.close(0);
                        }
                      },
                      child: const Text("Save"))
                ],
              )),
        ),
      ],
    );
  }
}
