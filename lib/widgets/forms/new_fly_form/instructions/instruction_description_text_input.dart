import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InstructionDescriptionTextInput extends StatelessWidget {
  final String initialValue;
  final String label;
  final String attribute;

  InstructionDescriptionTextInput(
      {this.initialValue, this.label, this.attribute});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      attribute: attribute,
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 10,
      validators: [
        FormBuilderValidators.required(),
        FormBuilderValidators.max(70),
      ],
    );
  }
}
