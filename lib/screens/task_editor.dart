import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets/description_editor.dart';
import 'package:todo_app/widgets/task_metadata.dart';

class TaskEditorScreen extends StatefulWidget {
  Task task;
  String title = "Tasks";
  bool readOnly;
  TaskEditorScreen({super.key, required this.task, this.readOnly = false});

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  bool _wasChanges = false;
  bool _readOnly = false;
  late FocusNode _taskEditorFocusNode;

  @override
  void initState() {
    super.initState();
    _readOnly = widget.readOnly;
    _taskEditorFocusNode = FocusNode();
    if (_readOnly == false) _taskEditorFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    TextButton cancelCloseButton = TextButton.icon(
        onPressed: _cancelTask,
        icon: _readOnly
            ? const Icon(Icons.close_outlined)
            : const Icon(Icons.cancel_outlined),
        label: Text(_readOnly ? "Close" : "Cancel"));
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Editor"),
            ],
          ),
          actions: [
            if (_readOnly) ...[
              IconButton(
                  tooltip: "Edit Task",
                  onPressed: _enterEditorMode,
                  icon: const Icon(Icons.edit)),
              if (widget.task.completed) ...[
                IconButton(
                    tooltip: "Work in progress",
                    onPressed: _wipTask,
                    icon: const Icon(Icons.remove_done)),
              ] else ...[
                IconButton(
                    tooltip: "Complete...",
                    onPressed: _completeTask,
                    icon: const Icon(Icons.done)),
              ],
            ] else ...[
              IconButton(
                  tooltip: "Save changes",
                  onPressed: _saveTask,
                  icon: const Icon(Icons.save)),
            ],
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskMetadata(task: widget.task, readOnly: _readOnly),
            Expanded(
              child: GestureDetector(
                onDoubleTap: _readOnly ? _enterEditorMode : null,
                child: DescriptionEditor(
                  editorFocusNode: _taskEditorFocusNode,
                  initialDescription:
                      widget.task.description.replaceAll("\\n", "\n"),
                  onDescriptionChanged: _updateDescription,
                  readOnly: _readOnly,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ButtonBar(
          children: [
            cancelCloseButton,
            if (!_readOnly) ...[
              TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary),
                  onPressed: _saveTask,
                  icon: const Icon(Icons.save),
                  label: const Text("Save")),
            ] else ...[
              TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary),
                  onPressed: _enterEditorMode,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit")),
            ]
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, _wasChanges);
    return false;
  }

  _updateDescription(String pDescription) {
    widget.task.description = pDescription.replaceAll("\n", "\\n");
  }

  _saveTask({bool popView = true}) async {
    print("Save");
    _wasChanges = true;
    _readOnly = true;
    widget.task.update();
    if (mounted) setState(() {});
    if (popView) {
      await _onWillPop();
    }
  }

  _cancelTask({bool popView = true}) async {
    print("Cancel");
    _wasChanges = false;
    if (mounted) setState(() {});
    if (popView) {
      await _onWillPop();
    }
  }

  _enterEditorMode() {
    _readOnly = false;
    _taskEditorFocusNode.requestFocus();
    if (mounted) setState(() {});
  }

  _completeTask({bool popView = true}) async {
    widget.task.completed = true;
    widget.task.completedAt = DateTime.now();
    _wasChanges = true;
    widget.task.update();
    if (mounted) setState(() {});
    if (popView) {
      await _onWillPop();
    }
  }

  _wipTask({bool popView = true}) async {
    widget.task.completed = false;
    widget.task.completedAt = null;
    _wasChanges = true;
    widget.task.update();
    if (mounted) setState(() {});
    if (popView) {
      await _onWillPop();
    }
  }
}
