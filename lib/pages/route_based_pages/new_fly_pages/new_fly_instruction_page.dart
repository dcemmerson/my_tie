/// filename: new_fly_instruction_page.dart
/// last modified: 08/31/2020
/// description: Page is for route which allows user to add a instructions for
///   how to tie a new fly to firestore.

import 'package:flutter/material.dart';
import 'package:my_tie/widgets/forms/new_fly_form/instructions/new_fly_form_instruction.dart';

class NewFlyInstructionPage extends StatelessWidget {
  static const title = 'Add Instructions';
  static const route = '/new_fly/add_new_instruction';

  @override
  Widget build(BuildContext context) {
    return NewFlyFormInstruction();
  }
}
