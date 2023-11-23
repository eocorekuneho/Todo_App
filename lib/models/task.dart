import 'package:flutter/material.dart';
import 'package:todo_app/models/tag.dart';
import 'package:todo_app/screens/task_editor.dart';
import 'package:todo_app/todo_txt.dart';

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
      List<Tag>? tags})
      : tags = tags ?? [];

  Task copyFrom(Task pSource) {
    return Task(
      completed: pSource.completed,
      completedAt: pSource.completedAt,
      createdAt: pSource.createdAt,
      description: pSource.description,
      priority: pSource.priority,
      tags: pSource.tags,
    );
  }

  Future<bool> show(BuildContext context) async {
    return await edit(context, readOnly: true);
  }

  Future<bool> edit(BuildContext context, {bool readOnly = false}) async {
    Task tempTask = Task().copyFrom(this);
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) =>
              TaskEditorScreen(task: tempTask, readOnly: readOnly)),
    );
    if (result == false) {
      return false;
    }
    completed = tempTask.completed;
    completedAt = tempTask.completedAt;
    createdAt = tempTask.createdAt;
    description = tempTask.description;
    priority = tempTask.priority;
    tags = tempTask.tags;
    return true;
  }

  void update() {
    Map<String, dynamic> parsedContent = TodoTxt.parseDescription(description);
    print(parsedContent);
    tags.clear();
    for (String k in parsedContent.keys) {
      if (k == "content") {
        description = parsedContent[k];
        continue;
      } else if (k == "projects") {
        if ((parsedContent[k] as List).isEmpty) continue;
        tags.addAll(
            (parsedContent[k] as List).map((e) => Tag(TagType.PROJECT, e)));
      } else if (k == "contexts") {
        if ((parsedContent[k] as List).isEmpty) continue;
        tags.addAll(
            (parsedContent[k] as List).map((e) => Tag(TagType.CONTEXT, e)));
      } else if (k == "keyvalues") {
        if ((parsedContent[k] as Map).isEmpty) continue;
        for (String kk in (parsedContent[k] as Map).keys) {
          tags.add(Tag(TagType.KEYVALUE, kk, value: parsedContent[k][kk]));
        }
      }
    }
  }
}
