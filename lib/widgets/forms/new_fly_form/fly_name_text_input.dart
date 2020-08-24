import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FlyNameTextInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      attribute: "Fly Name",
      decoration: InputDecoration(labelText: "Fly Name"),
      validators: [
        FormBuilderValidators.required(),
        FormBuilderValidators.max(70),
      ],
    );
  }
}
