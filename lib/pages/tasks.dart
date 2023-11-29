import 'package:flutter/material.dart';
import 'package:todo_app/lists/task_list.dart';
import 'package:todo_app/models/task.dart';
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
  late TodoFile _currentFile;
  late TextEditingController _textEditingController;
  String _filterText = "";
  FloatingActionButton fabTasks = FloatingActionButton(onPressed: () {});
  bool showFilterWarning = false;
  bool listFiltered = false;

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
          onPressed: () async {
            Task newTask = Task();
            bool taskOk = await newTask.edit(context);
            if (taskOk) {
              _currentFile.contents.taskAdd(newTask);
              await _currentFile.update();
              if (mounted) setState(() {});
              globals.currentFileNotifier.value = _currentFile;
            }
          });
      Future.delayed(const Duration(milliseconds: 5), () {
        widget.setFAB!(fabTasks);
      });
    }
  }

  _taskOnTap(Task pTask) {
    Navigator.of(context).push(
        (MaterialPageRoute(builder: (_) => TaskEditorScreen(task: pTask))));
  }

  @override
  Widget build(BuildContext context) {
    Color filter_fore_color = listFiltered
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onBackground;
    Color filter_bg_color = listFiltered
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.background;
    return Column(children: <Widget>[
      Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: filter_bg_color,
                  minimumSize: Size(36, 36),
                  shape: CircleBorder(),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  listFiltered = !listFiltered;
                  showFilterWarning = listFiltered;
                  if (mounted) setState(() {});
                },
                child: Icon(Icons.filter_list, color: filter_fore_color),
                //tooltip: "Sorty/Filter by Priority...",
              ),
              Expanded(
                  child: TextFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8, right: 8),
                          hintText:
                              "Search Tasks (in description, +Project or @context)..."),
                      controller: _textEditingController)),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.account_tree),
                      tooltip: "Select Project..."),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.alternate_email),
                    tooltip: "Select Context...",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      if (showFilterWarning)
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                      "Filtering list: by Priority (A-F), 2 +Project, 4 @context, 8 labels",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
                IconButton(
                  onPressed: () {
                    showFilterWarning = false;
                    listFiltered = false;
                    if (mounted) setState(() {});
                  },
                  icon: Icon(
                    Icons.filter_list_off,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showFilterWarning = false;
                    if (mounted) setState(() {});
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      Expanded(
          child: ValueListenableBuilder<TodoFile?>(
        valueListenable: globals.getCurrentFile,
        builder: (context, value, child) {
          if (value == null) {
            return Center(child: CircularProgressIndicator());
          }
          _currentFile = value;

          return TaskList(file: _currentFile, cbTaskOnTap: _taskOnTap);
        },
      )),
    ]);
  }
}
