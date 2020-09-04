import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InstructionNameTextInput extends StatelessWidget {
  final String initialValue;
  final String label;
  final String attribute;

  InstructionNameTextInput({this.initialValue, this.label, this.attribute});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      attribute: attribute,
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      validators: [
        FormBuilderValidators.required(),
        FormBuilderValidators.max(70),
      ],
    );
  }
}
