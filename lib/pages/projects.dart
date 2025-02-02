import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/lists/tag_list.dart';
import 'package:todo_app/models/tag.dart';
import 'package:todo_app/models/todo_file.dart';

class ProjectsPage extends StatefulWidget {
  ProjectsPage({super.key, this.setFAB});
  String title = "Projects";
  Function? setFAB;

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late TodoFile _currentFile;
  late TextEditingController _textEditingController;
  String _filterText = "";
  FloatingActionButton fabProjects = FloatingActionButton(
      tooltip: "Add new +Project...",
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
                top: constraints.constrainHeight() / 2 - 14,
                left: constraints.constrainWidth() / 2 - 14,
                child: const Icon(
                  Icons.account_tree,
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
        print("new project!");
      });

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: _filterText);
    if (widget.setFAB != null) {
      Future.delayed(const Duration(milliseconds: 5), () {
        widget.setFAB!(fabProjects);
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
                        hintText: "Search +Projects..."),
                    controller: _textEditingController))
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
          _currentFile = value;

          return TagList(
              file: _currentFile, type: TagType.PROJECT, cbTaskOnTap: () {});
        },
      )),
    ]);
  }
}
