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
  //List<Task> _taskList = [];

  _loadTasks(TodoFile pFile) {
    /*
    for (Task t in pFile.tasks.taskList.value) {
      _taskList.add(t);
    }
    */
    if (mounted) setState(() {});
  }

  _showTask(int pTaskIndex) async {
    bool result = await widget.file.tasks.tasks.value[pTaskIndex].show(context);
    if (result == true) {
      await widget.file.update();
    }
    if (mounted) setState(() {});
  }

  _editTask(int pTaskIndex) async {
    bool result = await widget.file.tasks.tasks.value[pTaskIndex].edit(context);
    if (result == true) {
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
      valueListenable: widget.file.tasks.tasks,
      builder: (context, value, child) {
        return ListView.separated(
            itemCount: value.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    _showTask(index);
                  },
                  child: TaskCard(task: value[index]));
            });
      },
    );
  }
}
