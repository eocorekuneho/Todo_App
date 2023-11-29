import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/models/tag.dart';
import 'package:todo_app/widgets/tag_card.dart';
import 'package:todo_app/models/todo_file.dart';

class TagList extends StatefulWidget {
  TodoFile file;
  Function? cbTaskOnTap;
  TagType type;
  TagList(
      {required this.file, required this.type, super.key, this.cbTaskOnTap});

  @override
  State<TagList> createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  _loadProjects(TodoFile pFile) {
    if (mounted) setState(() {});
  }

  _showEditTask(int pTaskIndex) async {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadProjects(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    late ValueListenable<List<Tag>> vListenable;
    if (widget.type == TagType.PROJECT) {
      vListenable = widget.file.contents.projects;
    } else if (widget.type == TagType.CONTEXT) {
      vListenable = widget.file.contents.contexts;
    } else if (widget.type == TagType.KEYVALUE) {
      vListenable = widget.file.contents.keyvalues;
    }
    return ValueListenableBuilder(
      valueListenable: vListenable,
      builder: (context, value, child) {
        return ListView.separated(
            itemCount: value.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              int countInTasks = widget.file.contents.tasks.value.where((task) {
                for (Tag t in task.tags) {
                  if (t.name == value[index].name) return true;
                }
                return false;
              }).length;

              //print(countInTasks);
              return InkWell(
                  onTap: () {
                    _showEditTask(index);
                  },
                  child: TagCard(project: value[index], count: countInTasks));
            });
      },
    );
  }
}
