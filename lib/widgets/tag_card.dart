import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/models/tag.dart';
import 'package:todo_app/models/task.dart';

class TagCard extends StatefulWidget {
  Tag project;
  int count;
  Function? cbOnTap;
  TagCard(
      {required this.project, required this.count, super.key, this.cbOnTap});

  @override
  State<TagCard> createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.project.name),
      subtitle: Text("subtitle"),
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.count.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}
