import 'package:flutter/material.dart';

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
  bool _isSkippableToEnd = false;

  get isSkippableToEnd => _isSkippableToEnd;
  set isSkippableToEnd(bool isSkippable) =>
      setState(() => _isSkippableToEnd = isSkippable);

  @override
  Widget build(BuildContext context) {
    return _NewFlyContainer(
      flyFormState: this,
      isSkippableToEnd: _isSkippableToEnd,
      child: widget.child,
    );
  }
}

class _NewFlyContainer extends InheritedWidget {
  final NewFlyState flyFormState;
  final bool isSkippableToEnd;

  _NewFlyContainer({
    Key key,
    @required this.flyFormState,
    @required Widget child,
    @required this.isSkippableToEnd,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_NewFlyContainer oldWidget) {
    return oldWidget.flyFormState != this.flyFormState ||
        oldWidget.isSkippableToEnd != this.isSkippableToEnd;
  }
}
