import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FlyNameTextInput extends StatelessWidget {
  final String flyInProgressName;
  final String label;
  final String attribute;

  FlyNameTextInput({this.flyInProgressName, this.label, this.attribute});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      key: ValueKey(attribute),
      attribute: attribute,
      decoration: InputDecoration(labelText: label),
      initialValue: flyInProgressName,
      validators: [
        FormBuilderValidators.required(),
        FormBuilderValidators.max(70),
      ],
    );
  }
}
