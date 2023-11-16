import 'package:flutter/material.dart';
import 'package:todo_app/lists/task_list.dart';
import 'package:todo_app/models/todo_file.dart';
import 'package:todo_app/screens/task_editor.dart';
import 'package:todo_app/globals.dart' as globals;

class TasksPage extends StatefulWidget {
  TasksPage({super.key, this.setFAB});
  String title = "Tasks";
  Function? setFAB;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late TextEditingController _textEditingController;
  String _filterText = "";
  FloatingActionButton fabTasks = FloatingActionButton(onPressed: () {});

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: _filterText);
    if (widget.setFAB != null) {
      fabTasks = FloatingActionButton(
          tooltip: "Create new Task...",
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Positioned(
                    top: constraints.constrainHeight() / 2 - 14,
                    left: constraints.constrainWidth() / 2 - 14,
                    child: const Icon(
                      Icons.task,
                      size: 24,
                    )),
                Positioned(
                    top: constraints.constrainHeight() / 2 - 2,
                    left: constraints.constrainWidth() / 2 - 2,
                    child: const Icon(
                      Icons.add,
                      size: 24,
                    ))
              ],
            ),
          ),
          onPressed: () {
            Navigator.of(context)
                .push((MaterialPageRoute(builder: (_) => TaskEditorScreen())));
          });
      Future.delayed(const Duration(milliseconds: 5), () {
        widget.setFAB!(fabTasks);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText:
                            "Search Tasks (in description, +Project or @context)..."),
                    controller: _textEditingController)),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.account_tree),
                tooltip: "Select Project..."),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.alternate_email),
              tooltip: "Select Context...",
            )
          ],
        ),
      ),
      Expanded(
          child: ValueListenableBuilder<TodoFile?>(
        valueListenable: globals.getCurrentFile,
        builder: (context, value, child) {
          if (value == null) {
            return Center(child: CircularProgressIndicator());
          }
          print(value);
          return TaskList(file: value);
        },
      )),
    ]);
  }
}
