import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';

class ContextsPage extends StatefulWidget {
  ContextsPage({super.key, this.setFAB});
  String title = "Tasks";
  Function? setFAB;

  @override
  State<ContextsPage> createState() => _ContextsPageState();
}

class _ContextsPageState extends State<ContextsPage> {
  late TextEditingController _textEditingController;
  String _filterText = "";
  FloatingActionButton fabContexts = FloatingActionButton(
      tooltip: "Add new Context...",
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
                top: constraints.constrainHeight() / 2 - 14,
                left: constraints.constrainWidth() / 2 - 14,
                child: const Icon(
                  Icons.alternate_email,
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
        print("new context!");
      });

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: _filterText);
    if (widget.setFAB != null) {
      Future.delayed(const Duration(milliseconds: 5), () {
        widget.setFAB!(fabContexts);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Search @contexts..."),
                      controller: _textEditingController))
            ],
          ),
        ),
        Expanded(child: ListView()),
      ],
    );
  }
}
