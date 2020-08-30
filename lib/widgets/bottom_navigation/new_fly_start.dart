import 'package:flutter/material.dart';
import 'package:my_tie/routes/fly_form_routes.dart';

class NewFlyStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('ehllo'),
        onPressed: () => FlyFormRoutes.newFlyAttributesPage(context),
      ),
    );

    // return NewFlyFormAttributes();
  }
}
