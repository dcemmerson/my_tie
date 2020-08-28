import 'package:flutter/material.dart';

import '../bloc_provider.dart';

class FlyFormStateContainer extends StatefulWidget {
  final Widget child;

  const FlyFormStateContainer({Key key, @required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => NewFlyState();

  static NewFlyState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_NewFlyContainer)
            as _NewFlyContainer)
        .flyFormState;
  }
}

class NewFlyState extends State<FlyFormStateContainer> {
  int pageCount;
  int currentPage;

  @override
  Widget build(BuildContext context) {
    return _NewFlyContainer(
      flyFormState: this,
      currentPage: currentPage,
      pageCount: pageCount,
      child: widget.child,
    );
  }
}

class _NewFlyContainer extends InheritedWidget {
  final NewFlyState flyFormState;
  final int pageCount;
  final int currentPage;

  _NewFlyContainer({
    Key key,
    @required this.flyFormState,
    @required Widget child,
    @required this.currentPage,
    @required this.pageCount,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_NewFlyContainer oldWidget) {
    return oldWidget.flyFormState != this.flyFormState ||
        oldWidget.pageCount != this.pageCount ||
        oldWidget.currentPage != this.currentPage;
  }
}
