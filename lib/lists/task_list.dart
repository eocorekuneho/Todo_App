import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/widgets/task_card.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo_file.dart';

class TaskList extends StatefulWidget {
  TodoFile file;
  Function? cbTaskOnTap;
  TaskList({required this.file, super.key, this.cbTaskOnTap});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  _loadTasks(TodoFile pFile) {
    if (mounted) setState(() {});
  }

  _showEditTask(int pTaskIndex) async {
    Task tempTask =
        Task().copyFrom(widget.file.contents.tasks.value[pTaskIndex]);
    bool result = await tempTask.show(context);
    if (result == true) {
      widget.file.contents.tasks.value[pTaskIndex] = tempTask;
      await widget.file.update();
    }
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadTasks(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.file.contents.tasks,
      builder: (context, value, child) {
        return ListView.separated(
            itemCount: value.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    _showEditTask(index);
                  },
                  child: TaskCard(task: value[index]));
            });
      },
    );
  }
}
