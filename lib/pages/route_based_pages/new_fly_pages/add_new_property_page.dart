/// filename: add_new_property_page.dart
/// last modified: 08/31/2020
/// description: Page is for route which allows user to add a new atribute or
///   material field to firestore. This is used when user long presses over an
///   attribute field and would allow user to enter in new attribute or material.
///   For example, if user is adding a new fly and needs to set the target
///   species of this fly to albacore tuna, but albacore tuna is not an option
///   in firestore, user can user this page to manually enter this in, which we
///   will later validate in firestore.

import 'package:flutter/material.dart';
import 'package:my_tie/widgets/forms/new_fly_form/form_edit_database/add_new_property.dart';

class AddNewPropertyPage extends StatelessWidget {
  static const title = 'Add New Property';
  static const route = '/new_fly/add_new_property';

  @override
  Widget build(BuildContext context) {
    return AddNewProperty();
  }
}
