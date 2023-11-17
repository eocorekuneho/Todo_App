import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/models/tag.dart';
import 'package:todo_app/models/task.dart';

class TaskCard extends StatefulWidget {
  Task task;
  TaskCard({required this.task, super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tag> projects = widget.task.tags
        .where((element) => element.type == TagType.PROJECT)
        .toList();
    return ListTile(
      title: Text(widget.task.description),
      subtitle: Text(projects.map((e) => e.name).toList().join(", ")),
      leading: Column(
        children: [
          Text(
              widget.task.priority.name == "NONE"
                  ? ""
                  : widget.task.priority.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      onTap: () {},
      onLongPress: () {},
    );
  }
}
