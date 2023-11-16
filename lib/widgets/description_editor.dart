import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class DescriptionEditor extends StatefulWidget {
  DescriptionEditor({super.key, this.setFAB});
  String title = "Tasks";
  Function? setFAB;

  @override
  State<DescriptionEditor> createState() => _DescriptionEditorState();
}

class _DescriptionEditorState extends State<DescriptionEditor> {
  late RichTextController _textEditingController;
  String _descriptionText = "";

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
    _textEditingController = RichTextController(
        patternMatchMap: patternUser,
        onMatch: (List<String> matches) {
          // Do something with matches.
          //! P.S
          // as long as you're typing, the controller will keep updating the list.
        },
        deleteOnBack: false,
        // You can control the [RegExp] options used:
        regExpUnicode: true);
    _textEditingController.addListener(() {
      _descriptionText = _textEditingController.text;
      if (mounted) setState(() {});
    });
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
                    onPressed: () {},
                    icon: const Icon(Icons.account_tree)),
                IconButton(
                    tooltip: "Insert @context...",
                    onPressed: () {},
                    icon: const Icon(Icons.alternate_email)),
                IconButton(
                    tooltip: "Insert Special Tag...",
                    onPressed: () {},
                    icon: const Icon(Icons.label)),
                IconButton(
                    tooltip: "Insert Reference...",
                    onPressed: () {},
                    icon: const Icon(Icons.link)),
              ],
            ),
            Expanded(
              child: TextFormField(
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
            Text(
                "C: ${_descriptionText.length} | W: ${_descriptionText.split(" ").length}"),
          ],
        ));
  }
}
