import 'package:flutter/material.dart';

abstract class TabPage extends StatelessWidget {
  String get name;
  Widget get widget;

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}
