import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_file.dart';
import 'package:todo_app/pages/contexts.dart';
import 'package:todo_app/pages/projects.dart';
import 'package:todo_app/pages/tasks.dart';
import 'package:todo_app/globals.dart' as globals;
import 'package:todo_app/todo_txt.dart';
import 'package:todo_app/widgets/drawer.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();
final appGlobalKey = GlobalKey<_MyAppState>();
void main() {
  runApp(MyApp(
    key: appGlobalKey,
  ));
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  _MyAppState state = _MyAppState();

  ThemeData brightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.lightGreen,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightGreen, brightness: Brightness.light),
  );
  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.deepOrange,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange, brightness: Brightness.dark),
  );

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class GlobalFAB {
  final ValueNotifier<FloatingActionButton> fab =
      ValueNotifier<FloatingActionButton>(
          FloatingActionButton(onPressed: null));

  void setFAB(FloatingActionButton pFAB) {
    fab.value = pFAB;
  }
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  final GlobalFAB _fab = GlobalFAB();
  late TabController _tabController;
  String _currentFile = "Default";
  List<Page> _pages = [];

  @override
  void didChangeDependencies() async {
    // megnézzük, h. létezik e a mappánk
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      Page(
          widget: TasksPage(
            setFAB: setFloatingActionButton,
          ),
          icon: const Icon(Icons.task),
          label: "Tasks"),
      Page(
          widget: ProjectsPage(
            setFAB: setFloatingActionButton,
          ),
          icon: const Icon(Icons.account_tree),
          label: "Projects"),
      Page(
          widget: ContextsPage(
            setFAB: setFloatingActionButton,
          ),
          icon: const Icon(Icons.alternate_email),
          label: "Contexts"),
      Page(
          widget: TasksPage(
            setFAB: setFloatingActionButton,
          ),
          icon: const Icon(Icons.label),
          label: "Labels"),
    ];
    _tabController = TabController(
      vsync: this,
      length: _pages.length,
    );
    _tabController.addListener(() {
      _currentPageIndex = _tabController.index;
      if (mounted) setState(() {});
    });
    globals.createDefaultFile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  setFloatingActionButton(FloatingActionButton pFAB) {
    //_fab = pFAB;
    _fab.setFAB(pFAB);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) return Container();
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    ThemeData currentTheme;
    if (isDarkMode) {
      currentTheme = widget.darkTheme;
    } else {
      currentTheme = widget.brightTheme;
    }
    return MaterialApp(
        title: 'Todo',
        navigatorKey: globalNavigatorKey,
        scrollBehavior: AppScrollBehavior(),
        theme: widget.brightTheme,
        darkTheme: widget.darkTheme,
        themeMode: ThemeMode.system,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: currentTheme.colorScheme.primaryContainer,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_currentFile,
                    style: TextStyle(
                        color: currentTheme.colorScheme.onPrimaryContainer)),
                Text(_pages[_currentPageIndex].label,
                    style: TextStyle(
                        color: currentTheme.colorScheme.onPrimaryContainer,
                        fontSize: 14)),
              ],
            ),
          ),
          drawer: AppDrawer(),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _pages[0].widget,
              _pages[1].widget,
              _pages[2].widget,
              _pages[3].widget,
            ],
          ),
          bottomNavigationBar: Container(
            color: currentTheme.colorScheme.background,
            child: TabBar(
              controller: _tabController,
              tabs: [
                // Tasks
                Tab(
                  icon: _pages[0].icon,
                  text: _pages[0].label,
                ),
                // Projects
                Tab(
                  icon: _pages[1].icon,
                  text: _pages[1].label,
                ),
                // Contexts
                Tab(
                  icon: _pages[2].icon,
                  text: _pages[2].label,
                ),
                // Key-Values
                Tab(
                  icon: _pages[3].icon,
                  text: _pages[3].label,
                )
              ],
            ),
          ),
          floatingActionButton: ValueListenableBuilder(
            valueListenable: _fab.fab,
            builder: (context, value, child) {
              return value;
            },
          ),
        ));
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
