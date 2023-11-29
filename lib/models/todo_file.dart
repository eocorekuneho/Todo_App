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

  TodoFileNotifiers contents = TodoFileNotifiers();

  List<Map> _tkeyvalues = [];

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
      contents.projectClearList();
      contents.contextClearList();
      contents.keyvalueClearList();
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
        contents.taskAdd(Task(
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

        for (String p in todoitem['projects']) {
          contents.projectAdd(Tag(TagType.PROJECT, p));
        }
        for (String p in todoitem['contexts']) {
          contents.contextAdd(Tag(TagType.CONTEXT, p));
        }
        for (String k in (todoitem['keyvalues'] as Map).keys) {
          contents.keyvalueAdd(
              Tag(TagType.CONTEXT, k, value: todoitem['keyvalues'][k]));
        }

        print("tasks count: ${contents.tasks.value.length}");
        print("projects count: ${contents.projects.value.length}");
        print("contexts count: ${contents.contexts.value.length}");
        print("keyvalues count: ${contents.keyvalues.value.length}");
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
    for (Task t in contents.tasks.value) {
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

class TodoFileNotifiers {
  final ValueNotifier<List<Task>> tasks = ValueNotifier<List<Task>>([]);
  final ValueNotifier<List<Tag>> projects = ValueNotifier<List<Tag>>([]);
  final ValueNotifier<List<Tag>> contexts = ValueNotifier<List<Tag>>([]);
  final ValueNotifier<List<Tag>> keyvalues = ValueNotifier<List<Tag>>([]);

  // tasks

  void setTaskList(List<Task> pTaskList) {
    tasks.value = pTaskList;
  }

  void taskUpdateAt(int index, Task pTask) {
    List<Task> tVal = tasks.value;
    tVal[index] = pTask;
    tasks.value = tVal;
  }

  void taskAdd(Task pTask) {
    List<Task> tVal = tasks.value;
    tVal.add(pTask);
    tasks.value = tVal;
  }

  void taskRemove(Task pTask) {
    List<Task> tVal = tasks.value;
    tVal.remove(pTask);
    tasks.value = tVal;
  }

  void taskRemoveAt(int pIndex) {
    List<Task> tVal = tasks.value;
    tVal.removeAt(pIndex);
    tasks.value = tVal;
  }

  void taskLoadList(List<Task> pTaskList) {
    List<Task> tVal = tasks.value;
    tVal.clear();
    tVal = pTaskList;
    tasks.value = tVal;
  }

  void taskClearList() {
    List<Task> tVal = tasks.value;
    tVal.clear();
    tasks.value = tVal;
  }

  // projects

  void setProjectList(List<Tag> pTagList) {
    projects.value = pTagList;
  }

  void projectUpdateAt(int index, Tag pTag) {
    List<Tag> tVal = projects.value;
    tVal[index] = pTag;
    projects.value = tVal;
  }

  void projectAdd(Tag pTag) {
    List<Tag> tVal = projects.value;
    tVal.add(pTag);
    projects.value = tVal;
  }

  void projectRemove(Tag pTag) {
    List<Tag> tVal = projects.value;
    tVal.remove(pTag);
    projects.value = tVal;
  }

  void projectRemoveAt(int pIndex) {
    List<Tag> tVal = projects.value;
    tVal.removeAt(pIndex);
    projects.value = tVal;
  }

  void projectLoadList(List<Tag> pTagList) {
    List<Tag> tVal = projects.value;
    tVal.clear();
    tVal = pTagList;
    projects.value = tVal;
  }

  void projectClearList() {
    List<Tag> tVal = projects.value;
    tVal.clear();
    projects.value = tVal;
  }

  // contexts

  void contextUpdateAt(int index, Tag pTag) {
    List<Tag> tVal = contexts.value;
    tVal[index] = pTag;
    contexts.value = tVal;
  }

  void contextAdd(Tag pTag) {
    List<Tag> tVal = contexts.value;
    tVal.add(pTag);
    contexts.value = tVal;
  }

  void contextRemove(Tag pTag) {
    List<Tag> tVal = contexts.value;
    tVal.remove(pTag);
    contexts.value = tVal;
  }

  void contextRemoveAt(int pIndex) {
    List<Tag> tVal = contexts.value;
    tVal.removeAt(pIndex);
    contexts.value = tVal;
  }

  void contextLoadList(List<Tag> pTagList) {
    List<Tag> tVal = contexts.value;
    tVal.clear();
    tVal = pTagList;
    contexts.value = tVal;
  }

  void contextClearList() {
    List<Tag> tVal = contexts.value;
    tVal.clear();
    contexts.value = tVal;
  }

  // keyvalues

  void keyvalueUpdateAt(int index, Tag pTag) {
    List<Tag> tVal = keyvalues.value;
    tVal[index] = pTag;
    keyvalues.value = tVal;
  }

  void keyvalueAdd(Tag pTag) {
    List<Tag> tVal = keyvalues.value;
    tVal.add(pTag);
    keyvalues.value = tVal;
  }

  void keyvalueRemove(Tag pTag) {
    List<Tag> tVal = keyvalues.value;
    tVal.remove(pTag);
    keyvalues.value = tVal;
  }

  void keyvalueRemoveAt(int pIndex) {
    List<Tag> tVal = keyvalues.value;
    tVal.removeAt(pIndex);
    keyvalues.value = tVal;
  }

  void keyvalueLoadList(List<Tag> pTagList) {
    List<Tag> tVal = keyvalues.value;
    tVal.clear();
    tVal = pTagList;
    keyvalues.value = tVal;
  }

  void keyvalueClearList() {
    List<Tag> tVal = keyvalues.value;
    tVal.clear();
    keyvalues.value = tVal;
  }
}
