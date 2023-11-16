import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_file.dart';
import 'package:todo_app/globals.dart' as globals;

class AppDrawer extends StatefulWidget {
  AppDrawer({super.key});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateFiles() async {
    globals.getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              "Todo",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Files", style: Theme.of(context).textTheme.bodySmall),
          ),
          ...globals.loadedFiles
              .map((e) => ListTile(
                  leading: e.icon, title: Text(e.displayedName), onTap: () {}))
              .toList(),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("New file..."),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage files"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class Page {
  Widget widget;
  String label;
  Icon icon;
  Function? fabAction;
  Page(
      {required this.widget,
      required this.label,
      required this.icon,
      this.fabAction});
}
