import 'package:todo_app/models/tag.dart';

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
  String priority;
  DateTime? completedAt;
  DateTime? createdAt;
  String description;
  List<Tag> tags;

  Task(bool needsCreationDate,
      {this.completed = false,
      this.priority = "",
      this.completedAt,
      this.description = "",
      this.tags = const []}) {
    if (needsCreationDate) {
      this.createdAt = DateTime.now();
    }
  }
}
