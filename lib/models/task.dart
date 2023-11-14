import 'package:todo_app/models/tag.dart';

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
