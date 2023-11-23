import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/models/tag.dart';
import 'package:todo_app/models/task.dart';

class TaskCard extends StatefulWidget {
  Task task;
  Function? cbOnTap;
  TaskCard({required this.task, super.key, this.cbOnTap});

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
    Color backgroundColor = widget.task.completed
        ? Theme.of(context).colorScheme.secondaryContainer.withAlpha(84)
        : Theme.of(context).colorScheme.primaryContainer.withAlpha(84);
    Color foregroundColor = widget.task.completed
        ? Theme.of(context).colorScheme.onSecondaryContainer
        : Theme.of(context).colorScheme.onPrimaryContainer;
    List<Tag> projects = widget.task.tags
        .where((element) => element.type == TagType.PROJECT)
        .toList();
    TextStyle taskTextStyle = widget.task.completed
        ? TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Theme.of(context).colorScheme.tertiary)
        : const TextStyle(decoration: TextDecoration.none, color: null);
    return ListTile(
      tileColor: backgroundColor,
      textColor: foregroundColor,
      title: Text(
        widget.task.description,
        style: TextStyle().merge(taskTextStyle),
      ),
      subtitle: projects.isNotEmpty
          ? Text(projects.map((e) => e.name).toList().join(", "))
          : null,
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              widget.task.priority.name == "NONE"
                  ? ""
                  : widget.task.priority.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  .merge(taskTextStyle)),
        ],
      ),
    );
  }
}
