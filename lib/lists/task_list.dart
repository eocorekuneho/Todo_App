import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/lists/task_card.dart';
import 'package:todo_app/models/todo_file.dart';

class TaskList extends StatefulWidget {
  TodoFile file;
  TaskList({required this.file, super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: widget.file.tasks.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          return TaskCard(task: widget.file.tasks[index]);
        });
  }
}
