import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:todo_app/models/todo_file.dart';

const String todoFilePath = "/store";

List<TodoFile> loadedFiles = [];
late TodoFile currentFile;

Future<String?> fRead(String pFileName, {String pPath = todoFilePath}) async {
  log("$pFileName", name: "globals.fRead");
  log("$pPath", name: "globals.fRead");
  String? text;
  try {
    final Directory? directory = await getExternalStorageDirectory();
    if (directory == null) return text;
    final File file = File("${directory.path}$pPath/$pFileName");
    text = await file.readAsString();
    log("${directory.path}$pPath/$pFileName loaded successfully.",
        name: "globals.fRead");
  } catch (e) {
    //log("Error reading file: $pFileName. $e", name: "globals.fRead", error: e);
    text = null;
  }
  return text;
}

fWrite(String pFileName, String pText, {String pPath = todoFilePath}) async {
  log("$pFileName", name: "globals.fWrite");
  log("$pPath", name: "globals.fWrite");
  final Directory? directory = await getExternalStorageDirectory();
  if (directory == null) return;
  await Directory("${directory.path}$pPath/").create(recursive: true);
  final File file = File('${directory.path}$pPath/$pFileName');
  log("${directory.path}$pPath/$pFileName loaded successfully.");
  await file.writeAsString(pText);
  log("${pText.length} chrs written to $pPath/$pFileName");
}

Future<List<String>> listFolder({String pPath = todoFilePath}) async {
  final Directory? directory = await getExternalStorageDirectory();
  if (directory == null) return [];
  await Directory("${directory.path}$pPath/").create(recursive: true);
  final dir = Directory("${directory.path}$pPath");
  final List<FileSystemEntity> entities = await dir.list().toList();
  return entities.map((e) => e.path.split("/").last).toList();
}

void getFiles() async {
  loadedFiles.clear();
  List<String> filePaths = await listFolder();
  print(filePaths);
  if (filePaths.isNotEmpty) {
    for (String path in filePaths) {
      TodoFile todoFile = TodoFile(
          fileName: path, displayedName: path, icon: const Icon(Icons.note));
      await todoFile.createFile();
      loadedFiles.add(todoFile);
    }
  }
}

void createDefaultFile() async {
  var todo = TodoFile(
      displayedName: "Default",
      fileName: "default.txt",
      icon: const Icon(Icons.home));
  await todo.createFile();
  loadedFiles.add(todo);
  currentFileNotifier.value = loadedFiles.last;
}

final ValueNotifier<TodoFile?> currentFileNotifier = ValueNotifier(
  setCurrentFile(),
);
setCurrentFile({TodoFile? value}) {
  currentFile = value ??
      TodoFile(
          fileName: "__internal_error.txt",
          displayedName: "error",
          icon: const Icon(Icons.error));
}

ValueListenable<TodoFile?> get getCurrentFile => currentFileNotifier;
