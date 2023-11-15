import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets/description_editor.dart';

class TaskEditorScreen extends StatefulWidget {
  TaskEditorScreen({super.key, this.setFAB});
  String title = "Tasks";
  Function? setFAB;

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  @override
  void initState() {
    super.initState();
  }

  _taskCreationDateListOnChanged(value) async {
    if (value == 0) {
      if (_taskCreationDateListItems.length == 3) {
        _taskCreationDateListItems.remove(_taskCreationDateListItems.last);
        _taskCreationDateListValue = 0;
      }
    } else if (value == 1) {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: taskCreationDate,
          firstDate: DateTime(1950),
          //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime.now());
      if (pickedDate != null) {
        DropdownMenuItem _ddItm = DropdownMenuItem(
          value: 2,
          child: Text(
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}"),
        );
        if (_taskCreationDateListItems.length < 3) {
          _taskCreationDateListItems.add(_ddItm);
        } else {
          _taskCreationDateListItems[2] = _ddItm;
        }
        _taskCreationDateListValue = 2;
        taskCreationDate = pickedDate;
        taskHasCreationDate = true;
      } else {
        taskHasCreationDate = false;
        _taskCreationDateListValue = 0;
      }
    } else {
      taskHasCreationDate = true;
      taskCreationDate = DateTime.parse(
          (_taskCreationDateListItems[value].child as Text).data!);
      _taskCreationDateListValue = 2;
    }
    if (mounted) setState(() {});
  }

  _taskIsDoneListOnChanged(value) async {
    _taskIsDoneListValue = value;
    taskIsDone = _taskIsDoneListValue;
    if (taskIsDone) {}
    if (mounted) setState(() {});
  }

  _taskDoneDateListOnChanged(value) async {
    if (value == 0) {
      if (_taskDoneDateListItems.length == 3) {
        _taskDoneDateListItems.remove(_taskDoneDateListItems.last);
        _taskDoneDateListValue = 0;
      }
    } else if (value == 1) {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: taskDoneDate,
          firstDate: DateTime(1950),
          //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime.now());
      if (pickedDate != null) {
        DropdownMenuItem _ddItm = DropdownMenuItem(
          value: 2,
          child: Text(
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}"),
        );
        if (_taskDoneDateListItems.length < 3) {
          _taskDoneDateListItems.add(_ddItm);
        } else {
          _taskDoneDateListItems[2] = _ddItm;
        }
        _taskDoneDateListValue = 2;
        taskDoneDate = pickedDate;
      } else {
        _taskDoneDateListValue = 0;
      }
    } else {
      taskDoneDate =
          DateTime.parse((_taskDoneDateListItems[value].child as Text).data!);
      _taskDoneDateListValue = 2;
    }
    if (mounted) setState(() {});
  }

  _taskPriorityListOnChanged(value) async {
    _taskPriorityListValue = value;
    taskPriority = TaskPriority.values[value];
    if (taskIsDone) {}
    if (mounted) setState(() {});
  }

  bool taskHasCreationDate = false;
  DateTime taskCreationDate = DateTime.now();
  int _taskCreationDateListValue = 0;
  final List<DropdownMenuItem> _taskCreationDateListItems = [
    const DropdownMenuItem(value: 0, child: Text("Do not set Creation date")),
    const DropdownMenuItem(value: 1, child: Text("Pick date..."))
  ];

  bool taskIsDone = false;
  bool _taskIsDoneListValue = false;
  final List<DropdownMenuItem> _taskIsDoneListItems = [
    const DropdownMenuItem(value: false, child: Text("In progress")),
    const DropdownMenuItem(value: true, child: Text("Done"))
  ];

  DateTime taskDoneDate = DateTime.now();
  int _taskDoneDateListValue = 0;
  final List<DropdownMenuItem> _taskDoneDateListItems = [
    const DropdownMenuItem(value: 0, child: Text("---")),
    const DropdownMenuItem(value: 1, child: Text("Pick date..."))
  ];

  TaskPriority taskPriority = TaskPriority.NONE;
  int _taskPriorityListValue = 0;
  List<DropdownMenuItem> _taskPriorityListItems = [];

  String taskDescription = "";
  TextEditingController _taskDescriptionFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _taskPriorityListItems = TaskPriority.values
        .map((e) => DropdownMenuItem(child: Text(e.name), value: e.index))
        .toList();
    _taskDescriptionFieldController.text = taskDescription;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: currentTheme.colorScheme.primaryContainer,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Editor"),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.date_range),
                const SizedBox(width: 2 * 12),
                DropdownButton(
                  value: _taskCreationDateListValue,
                  items: _taskCreationDateListItems,
                  onChanged: _taskCreationDateListOnChanged,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.done),
                const SizedBox(width: 2 * 12),
                DropdownButton(
                  value: _taskIsDoneListValue,
                  items: _taskIsDoneListItems,
                  onChanged: _taskIsDoneListOnChanged,
                ),
                if (taskIsDone) ...[
                  const SizedBox(width: 2 * 12),
                  const Icon(Icons.date_range),
                  const SizedBox(width: 2 * 12),
                  DropdownButton(
                    value: _taskDoneDateListValue,
                    items: _taskDoneDateListItems,
                    onChanged: _taskDoneDateListOnChanged,
                  ),
                ]
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.priority_high),
                const SizedBox(width: 2 * 12),
                DropdownButton(
                  value: _taskPriorityListValue,
                  items: _taskPriorityListItems,
                  onChanged: _taskPriorityListOnChanged,
                )
              ],
            ),
          ),
          Expanded(
            child: DescriptionEditor(),
          )
        ],
      ),
    );
  }
}
