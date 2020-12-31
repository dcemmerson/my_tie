import 'package:flutter/material.dart';

import '../bloc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTieStateContainer extends StatefulWidget {
  static const initDarkMode = false;
  static const prefsCompactFlyListMode = true;
  static const prefsDarkMode = 'darkMode';
  static const prefsCompactFlyListModeKey = 'compactMode';
  static const prefsAllUsersEntries = 'allUsersEntries';

  final Widget child;
  final BlocProvider blocProvider;

  const MyTieStateContainer(
      {Key key, @required this.child, @required this.blocProvider})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MyTieState();

  static MyTieState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MyTieContainer)
            as _MyTieContainer)
        .myTieState;
  }
}

class MyTieState extends State<MyTieStateContainer> {
  SharedPreferences _prefs;
  BlocProvider get blocProvider => widget.blocProvider;
  // int _newFlyFormPageCount = -1;
  bool _isDarkMode = false;
  bool _isCompactFlyListMode = true;
  bool _allUsersEntries = true;

  // get pageCount => _newFlyFormPageCount;
  get isDarkMode => _isDarkMode;
  get isCompactFlyListMode => _isCompactFlyListMode;
  get allUsersEntries => _allUsersEntries;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    var initialDarkMode = _prefs.getBool(MyTieStateContainer.prefsDarkMode);

    var initialCompactFlyListMode =
        _prefs.getBool(MyTieStateContainer.prefsCompactFlyListModeKey);

    setState(() {
      _isDarkMode = initialDarkMode is bool
          ? initialDarkMode
          : MyTieStateContainer.initDarkMode;
      _isCompactFlyListMode = initialCompactFlyListMode is bool
          ? initialCompactFlyListMode
          : MyTieStateContainer.prefsCompactFlyListMode;
    });
  }

  void toggleDarkMode() {
    _prefs.setBool(MyTieStateContainer.prefsDarkMode, !_isDarkMode);
    setState(() => _isDarkMode = !_isDarkMode);
  }

  void toggleAllUsersEntries() {
    _prefs.setBool(MyTieStateContainer.prefsAllUsersEntries, !_allUsersEntries);
    setState(() => _allUsersEntries = !_allUsersEntries);
  }

  void toggleCompactFlyListMode() {
    _prefs.setBool(
        MyTieStateContainer.prefsCompactFlyListModeKey, !_isCompactFlyListMode);
    setState(() => _isCompactFlyListMode = !_isCompactFlyListMode);
  }

  @override
  Widget build(BuildContext context) {
    return _MyTieContainer(
      wasteagramState: this,
      // newFlyFormPageCount: _newFlyFormPageCount,
      isDarkMode: _isDarkMode,
      isCompactFlyListMode: _isCompactFlyListMode,
      allUsersEntries: _allUsersEntries,
      blocProvider: widget.blocProvider,
      child: widget.child,
    );
  }
}

class _MyTieContainer extends InheritedWidget {
  final MyTieState myTieState;
  final BlocProvider blocProvider;
  final bool isDarkMode;
  final bool isCompactFlyListMode;
  final bool allUsersEntries;

  _MyTieContainer({
    Key key,
    @required Widget child,
    @required this.myTieState,
    @required this.blocProvider,
    @required this.isDarkMode,
    @required this.allUsersEntries,
    @required this.isCompactFlyListMode,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MyTieContainer oldWidget) {
    return oldWidget.myTieState != this.myTieState ||
        oldWidget.isDarkMode != this.isDarkMode ||
        oldWidget.isCompactFlyListMode != this.isCompactFlyListMode ||
        oldWidget.allUsersEntries != this.allUsersEntries;
  }
}
