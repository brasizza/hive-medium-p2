import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? tag;
  @HiveField(4, defaultValue: false)
  bool done;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.tag,
    this.done = false,
  });
}
