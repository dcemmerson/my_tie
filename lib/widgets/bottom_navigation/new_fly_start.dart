import 'package:flutter/material.dart';
import 'package:my_tie/routes/routes.dart';

class NewFlyStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('ehllo'),
        onPressed: () => Routes.newFlyAttributesPage(context),
      ),
    );

    // return NewFlyFormAttributes();
  }
}
