import 'package:todo_app/models/tag.dart';
import 'package:todo_app/models/todo_file.dart';

enum TaskPriority {
  NONE,
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P,
  Q,
  R,
  S,
  T,
  U,
  V,
  W,
  X,
  Y,
  Z
}

class Task {
  bool completed;
  TaskPriority priority;
  DateTime? completedAt;
  DateTime? createdAt;
  String description;
  List<Tag> tags;

  Task(
      {this.completed = false,
      this.completedAt,
      this.priority = TaskPriority.NONE,
      this.createdAt,
      this.description = "",
      this.tags = const []}) {}
}
