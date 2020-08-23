import 'package:flutter/material.dart';

import 'bloc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTieStateContainer extends StatefulWidget {
  static const initDarkMode = false;
  static const initCompactWasteListMode = true;
  static const prefsDarkMode = 'darkMode';
  static const prefsCompactWasteListMode = 'compactMode';
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
        .wasteagramState;
  }
}

class MyTieState extends State<MyTieStateContainer> {
  SharedPreferences _prefs;

  BlocProvider get blocProvider => widget.blocProvider;
  bool _isDarkMode = false;
  bool _isCompactWasteListMode = true;
  bool _allUsersEntries = true;

  get isDarkMode => _isDarkMode;
  get isCompactWasteListMode => _isCompactWasteListMode;
  get allUsersEntries => _allUsersEntries;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    var initialDarkMode = _prefs.getBool(MyTieStateContainer.prefsDarkMode);

    var initialCompactWasteListMode =
        _prefs.getBool(MyTieStateContainer.prefsCompactWasteListMode);

    setState(() {
      _isDarkMode = initialDarkMode is bool
          ? initialDarkMode
          : MyTieStateContainer.initDarkMode;
      _isCompactWasteListMode = initialCompactWasteListMode is bool
          ? initialCompactWasteListMode
          : MyTieStateContainer.initCompactWasteListMode;
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

  void toggleCompactWasteListMode() {
    _prefs.setBool(MyTieStateContainer.prefsCompactWasteListMode,
        !_isCompactWasteListMode);
    setState(() => _isCompactWasteListMode = !_isCompactWasteListMode);
  }

  @override
  Widget build(BuildContext context) {
    return _MyTieContainer(
      wasteagramState: this,
      isDarkMode: _isDarkMode,
      isCompactWasteListMode: _isCompactWasteListMode,
      allUsersEntries: _allUsersEntries,
      blocProvider: widget.blocProvider,
      child: widget.child,
    );
  }
}

class _MyTieContainer extends InheritedWidget {
  final MyTieState wasteagramState;
  final BlocProvider blocProvider;
  final bool isDarkMode;
  final bool isCompactWasteListMode;
  final bool allUsersEntries;

  _MyTieContainer({
    Key key,
    @required this.wasteagramState,
    @required Widget child,
    @required this.blocProvider,
    @required this.isDarkMode,
    @required this.allUsersEntries,
    @required this.isCompactWasteListMode,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MyTieContainer oldWidget) {
    return oldWidget.wasteagramState != this.wasteagramState ||
        oldWidget.isDarkMode != this.isDarkMode ||
        oldWidget.isCompactWasteListMode != this.isCompactWasteListMode ||
        oldWidget.allUsersEntries != this.allUsersEntries;
  }
}
