import 'package:flutter/material.dart';

abstract class BottomNavPageBase extends StatelessWidget {
  get title;

  @override
  Widget build(BuildContext context);
}
