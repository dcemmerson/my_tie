import 'package:flutter/material.dart';
import 'package:my_tie/routes/fly_form_routes.dart';

class NewFlyStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: 'New Fly Button',
        hint: 'Tap to add new fly',
        button: true,
        child: RaisedButton(
          key: ValueKey('addNewFlyButton'),
          child: Text('Add new fly'),
          onPressed: () => FlyFormRoutes.newFlyPublishPage(context),
        ),
      ),
    );

    // return NewFlyFormAttributes();
  }
}
