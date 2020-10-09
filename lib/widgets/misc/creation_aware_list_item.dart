/// filname: creation_aware_list_item.dart
/// description: Used as a wrapper around lazy loaded widgets to signal when
///   an item is actually instantiated to the parent class.
///
///   Adaptation from https://medium.com/flutter-community/infinite-scroll-list-
///   in-pure-flutter-using-an-index-not-the-controller-8eec77d52bfb

import 'package:flutter/material.dart';

class CreationAwareWidget extends StatefulWidget {
  final Function itemCreated;
  final Widget child;

  const CreationAwareWidget({Key key, this.itemCreated, this.child})
      : super(key: key);

  @override
  _CreationAwareWidgetState createState() => _CreationAwareWidgetState();
}

class _CreationAwareWidgetState extends State<CreationAwareWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.itemCreated != null) {
      widget.itemCreated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
