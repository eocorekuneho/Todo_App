import 'package:flutter/material.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/models/tag.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/todo_txt.dart';

class TodoFile {
  String displayedName;
  String fileName;
  String _contents = "";
  late DateTime updatedAt;
  Icon icon;
  bool _ready = false;

  TaskListNotifier tasks = TaskListNotifier();

  //List<Task> tasks = [];
  List<Tag> projects = [];
  List<Tag> contexts = [];

  TodoFile(
      {required this.fileName,
      required this.displayedName,
      required this.icon}) {
    updatedAt = DateTime.now();
    _ready = false;
  }

  Future<bool> loadFile() async {
    String? cnt = await globals.fRead(fileName);
    if (cnt == null) {
      _contents = "";
      _ready = false;
      return false;
    } else {
      _contents = cnt;
      _ready = true;

      var result = TodoTxt.parseContents(_contents);
      /*
        "done": false,
      "priority": "",
      "createdAt": "",
      "finishedAt": "",
      "content": "",
      "projects": [],
      "contexts": [],
      "keyvalues": {},
*/
      for (Map<String, dynamic> todoitem in result) {
        tasks.add(Task(
            createdAt: todoitem['createdAt'],
            completed: todoitem['done'],
            completedAt: todoitem['finishedAt'],
            description: todoitem['content'],
            priority: todoitem['priority'] == null
                ? TaskPriority.NONE
                : TaskPriority.values
                        .where(
                            (element) => element.name == todoitem['priority'])
                        .firstOrNull ??
                    TaskPriority.NONE,
            tags: [
              ...(todoitem['projects'] as List)
                  .map((e) => Tag(TagType.PROJECT, e))
                  .toList(),
              ...(todoitem['contexts'] as List)
                  .map((e) => Tag(TagType.CONTEXT, e))
                  .toList(),
              ...(todoitem['keyvalues'] as Map)
                  .keys
                  .map((key) => Tag(TagType.KEYVALUE, key,
                      value: (todoitem['keyvalues'] as Map)[key]))
                  .toList(),
            ]));
      }
      return true;
    }
  }

  Future<void> createFile() async {
    if (!await loadFile()) {
      print("creating");
      String header = "// default.txt\r\n// Created at $updatedAt";
      globals.fWrite(fileName, header);
      await loadFile();
    } else {
      print("already exists, loaded");
    }
  }

  String getFileHeader() {
    return "// created with TodoApp";
  }

  Future<void> saveFile() async {
    String output = getFileHeader();
    for (Task t in tasks.tasks.value) {
      output += "\r\n";
      String taskLine = "";
      if (t.completed) {
        taskLine += "x ";
      }
      if (t.priority != TaskPriority.NONE) {
        taskLine += "(${t.priority.name}) ";
      }
      if (t.completedAt != null) {
        taskLine += "${t.completedAt.toString().substring(0, 10)} ";
      }
      if (t.createdAt != null) {
        taskLine += "${t.createdAt.toString().substring(0, 10)} ";
      }
      taskLine += t.description;

      output += taskLine;
    }
    await globals.fWrite(fileName, output);
  }

  String? getContents() {
    if (this._ready)
      return _contents;
    else
      return null;
  }

  Future<void> update() async {
    await saveFile();
  }
}

class TaskListNotifier {
  final ValueNotifier<List<Task>> tasks = ValueNotifier<List<Task>>([]);

  void setTaskList(List<Task> pTaskList) {
    tasks.value = pTaskList;
  }

  void updateAt(int index, Task pTask) {
    List<Task> tVal = tasks.value;
    tVal[index] = pTask;
    tasks.value = tVal;
  }

  void add(Task pTask) {
    List<Task> tVal = tasks.value;
    tVal.add(pTask);
    tasks.value = tVal;
  }

  void remove(Task pTask) {
    List<Task> tVal = tasks.value;
    tVal.remove(pTask);
    tasks.value = tVal;
  }

  void removeAt(int pIndex) {
    List<Task> tVal = tasks.value;
    tVal.removeAt(pIndex);
    tasks.value = tVal;
  }

  void load(List<Task> pTaskList) {
    List<Task> tVal = tasks.value;
    tVal.clear();
    tVal = pTaskList;
    tasks.value = tVal;
  }

  void clear() {
    List<Task> tVal = tasks.value;
    tVal.clear();
    tasks.value = tVal;
  }
}
