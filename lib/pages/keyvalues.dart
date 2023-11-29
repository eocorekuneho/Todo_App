import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/lists/tag_list.dart';
import 'package:todo_app/models/tag.dart';
import 'package:todo_app/models/todo_file.dart';

class KeyValuesPage extends StatefulWidget {
  KeyValuesPage({super.key, this.setFAB});
  String title = "Labels";
  Function? setFAB;

  @override
  State<KeyValuesPage> createState() => _KeyValuesPageState();
}

class _KeyValuesPageState extends State<KeyValuesPage> {
  late TodoFile _currentFile;
  late TextEditingController _textEditingController;
  String _filterText = "";
  FloatingActionButton fabKeyValues = FloatingActionButton(onPressed: null);

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: _filterText);
    if (widget.setFAB != null) {
      Future.delayed(const Duration(milliseconds: 5), () {
        widget.setFAB!(fabKeyValues);
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
                        hintText: "Search Labels..."),
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
              file: _currentFile, type: TagType.KEYVALUE, cbTaskOnTap: () {});
        },
      )),
    ]);
  }
}
