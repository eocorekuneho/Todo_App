import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class TaskMetadata extends StatefulWidget {
  Task task;
  bool readOnly;
  Function? cbMetadataChanged;
  TaskMetadata(
      {super.key,
      required this.task,
      this.cbMetadataChanged,
      this.readOnly = false});
  @override
  State<TaskMetadata> createState() => _TaskMetadata();
}

class _TaskMetadata extends State<TaskMetadata> {
  late DateTime? _createdAt;
  late bool _completed;
  late DateTime? _completedAt;
  late TaskPriority _priority;

  @override
  void initState() {
    super.initState();
    _createdAt = widget.task.createdAt;
    _completed = widget.task.completed;
    _completedAt = widget.task.completedAt;
    _priority = widget.task.priority;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  Future<void> _metadataDialogBuilder(BuildContext context) {
    bool isCompleted = _completed;
    TaskPriority taskPriority = _priority;
    DateTime? dateCompleted = _completedAt;
    DateTime? dateCreated = _createdAt;
    String dateCreatedText =
        _createdAt != null ? _createdAt.toString().substring(0, 10) : "";
    TextEditingController controllerDateCreated =
        TextEditingController(text: dateCreatedText);
    String dateCompletedText =
        _completedAt != null ? _completedAt.toString().substring(0, 10) : "";
    TextEditingController controllerDateCompleted =
        TextEditingController(text: dateCompletedText);
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Task properties",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("CANCEL")),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _completed = isCompleted;
                                _completedAt = dateCompleted;
                                _createdAt = dateCreated;
                                _priority = taskPriority;
                              });
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                                foregroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.onPrimary)),
                            child: const Text("SET")),
                      ],
                    )
                  ],
                ),
                const Divider(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Finished
                        DropdownButtonFormField<bool>(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(20.0),
                            label: Wrap(
                              children: [
                                Icon(Icons.done),
                                Text("State"),
                              ],
                            ),
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.always,
                          value: isCompleted,
                          items: [true, false].map(
                            (bool value) {
                              return DropdownMenuItem<bool>(
                                value: value,
                                child: Text(
                                  value ? "Done" : "Work in progress",
                                ),
                              );
                            },
                          ).toList(),
                          hint: const Text("Choose"),
                          onChanged: (bool? value) {
                            setSheetState(() {
                              isCompleted = value ?? false;
                            });
                          },
                          validator: (bool? value) {
                            return value == null ? "Choose" : null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Priority
                        DropdownButtonFormField<TaskPriority>(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(20.0),
                            label: Wrap(
                              children: [
                                Icon(Icons.priority_high),
                                Text("Priority"),
                              ],
                            ),
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.always,
                          value: taskPriority,
                          items: TaskPriority.values.map(
                            (TaskPriority priority) {
                              return DropdownMenuItem<TaskPriority>(
                                value: priority,
                                child: Text(
                                  priority.name,
                                ),
                              );
                            },
                          ).toList(),
                          hint: const Text("Choose"),
                          onChanged: (TaskPriority? value) {
                            taskPriority = value ?? TaskPriority.NONE;
                          },
                          validator: (TaskPriority? value) {
                            return value == null ? "Select Priority" : null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Divider(height: 12),
                        const SizedBox(height: 15),
                        // Created at
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controllerDateCreated,
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          dateCreated ?? DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2199));
                                  setSheetState(() {
                                    if (pickedDate != null) {
                                      dateCreated = pickedDate;
                                      controllerDateCreated.text = pickedDate
                                          .toString()
                                          .substring(0, 10);
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                  label: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(Icons.date_range),
                                      Text("Creation date"),
                                    ],
                                  ),
                                  fillColor: Colors.transparent,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setSheetState(() {
                                  dateCreated = null;
                                  controllerDateCreated.text = "";
                                });
                              },
                            ),
                          ],
                        ),
                        if (isCompleted) ...[
                          const SizedBox(height: 15),
                          // Completed at
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controllerDateCompleted,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            dateCompleted ?? DateTime.now(),
                                        firstDate: DateTime(1950),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2199));
                                    setSheetState(() {
                                      if (pickedDate != null) {
                                        dateCompleted = pickedDate;
                                        controllerDateCompleted.text =
                                            pickedDate
                                                .toString()
                                                .substring(0, 10);
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    label: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Icon(Icons.date_range),
                                        Text("Completion date"),
                                      ],
                                    ),
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setSheetState(() {
                                    dateCompleted = null;
                                    controllerDateCompleted.text = "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _completed
        ? Theme.of(context).colorScheme.secondaryContainer
        : Theme.of(context).colorScheme.primaryContainer;
    Color foregroundColor = _completed
        ? Theme.of(context).colorScheme.onSecondaryContainer
        : Theme.of(context).colorScheme.onPrimaryContainer;
    // TODO: nem frissül be dátumállításkor
    return InkWell(
      onTap: (!widget.readOnly)
          ? () async {
              await _metadataDialogBuilder(context);
              widget.task.priority = _priority;
              widget.task.createdAt = _createdAt;
              widget.task.completedAt = _completedAt;
              widget.task.completed = _completed;
              if (mounted) setState(() {});
            }
          : null,
      child: Card(
        color: backgroundColor,
        child: DefaultTextStyle(
          style: TextStyle(color: foregroundColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text("Priority: "),
                        Text(
                          _priority.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                      if (widget.task.createdAt != null) ...[
                        Row(children: [
                          const Text("Created at: "),
                          Text(
                            _createdAt.toString().substring(0, 10),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ],
                      Row(
                        children: [
                          if (_completed == false) ...[
                            const Text(
                              "Work in progress",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ] else ...[
                            const Text(
                              "Task finished",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (_completedAt != null)
                              Text(
                                  " @ ${_completedAt.toString().substring(0, 10)}")
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (!widget.readOnly)
                  Icon(
                    Icons.edit,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .color!
                        .withAlpha(128),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
