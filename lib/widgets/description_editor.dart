import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

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
  late RichTextController _textEditingController;
  int _wordCount = 0, _charCount = 0;

  Map<RegExp, TextStyle> patternUser = {
    // project
    RegExp(r"\+[a-zA-Z0-9\p{L}\p{M}]+"):
        const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    // context
    RegExp(r"\B@[a-zA-Z0-9\p{L}\p{M}]+"):
        const TextStyle(fontStyle: FontStyle.italic)
  };

  @override
  void initState() {
    super.initState();
    _description = widget.initialDescription;
    _charCount = _description.characters.length;
    _wordCount = _description.split(" ").length - 1;
    _textEditingController = RichTextController(
        patternMatchMap: patternUser,
        onMatch: (List<String> matches) {
          // Do something with matches.
          //! P.S
          // as long as you're typing, the controller will keep updating the list.
        },
        deleteOnBack: false,
        // You can control the [RegExp] options used:
        regExpUnicode: true,
        text: _description);
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
