import 'package:flutter/material.dart';
import 'package:todo_app/controllers/description_editor_controller.dart';
import 'package:todo_app/todo_txt.dart';

class DescriptionEditor extends StatefulWidget {
  DescriptionEditor(
      {super.key,
      this.setFAB,
      required this.initialDescription,
      required this.onDescriptionChanged,
      this.editorFocusNode,
      this.readOnly = false});
  String title = "Tasks";
  Function? setFAB;
  String initialDescription;
  bool readOnly;
  final ValueChanged<String> onDescriptionChanged;
  FocusNode? editorFocusNode;

  @override
  State<DescriptionEditor> createState() => _DescriptionEditorState();
}

class _DescriptionEditorState extends State<DescriptionEditor> {
  late String _description;
  late DescriptionEditorController _textEditingController;
  int _wordCount = 0, _charCount = 0;

  List<DescriptionEditorKeyword> userPattern = [
    DescriptionEditorKeyword(
      prefix: TodoTxt.PREFIX_CONTEXT,
      pattern: TodoTxt.REGEX_CONTEXT,
      textStyle: const TextStyle(fontStyle: FontStyle.italic),
    ),
    DescriptionEditorKeyword(
      prefix: TodoTxt.PREFIX_PROJECT,
      pattern: TodoTxt.REGEX_PROJECT,
      textStyle:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
    ),
    DescriptionEditorKeyword(
      prefix: "",
      keyCharacter: TodoTxt.KEYCHAR_KEYVALUE,
      pattern: TodoTxt.REGEX_KEYVALUE,
      textStyle: TextStyle(backgroundColor: Colors.orange.withAlpha(128)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _description = widget.initialDescription;
    _charCount = _description.characters.length;
    _wordCount = _description.split(" ").length - 1;
    _textEditingController =
        DescriptionEditorController(userPattern, text: _description);
    _textEditingController.addListener(() {
      _description = _textEditingController.text;
      _charCount = _description.characters.length;
      _wordCount = _description.split(" ").length - 1;
      if (mounted) setState(() {});
      widget.onDescriptionChanged(_description);
    });
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    tooltip: "Insert +Project...",
                    onPressed: widget.readOnly ? null : () {},
                    icon: const Icon(Icons.account_tree)),
                IconButton(
                    tooltip: "Insert @context...",
                    onPressed: widget.readOnly ? null : () {},
                    icon: const Icon(Icons.alternate_email)),
                IconButton(
                    tooltip: "Insert Special Tag...",
                    onPressed: widget.readOnly ? null : () {},
                    icon: const Icon(Icons.label)),
                IconButton(
                    tooltip: "Insert Reference...",
                    onPressed: widget.readOnly ? null : () {},
                    icon: const Icon(Icons.link)),
              ],
            ),
            Expanded(
              child: TextFormField(
                focusNode: widget.editorFocusNode,
                readOnly: widget.readOnly,
                controller: _textEditingController,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  // TODO: ez a szín
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  hoverColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  filled: true,
                ),
              ),
            ),
            Text("C: $_charCount | W: $_wordCount"),
          ],
        ));
  }
}
