import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/models/arguments/add_property_argument.dart';
import 'package:my_tie/widgets/forms/new_fly_form/field_long_press_wrapper.dart';

class FlyAttributeDropdown extends StatelessWidget {
  // final _underlineSuccess = Container(height: 2, color: AppColors.success);
  // final _underlineError = Container(height: 2, color: AppColors.error);
  final List<String> flyProperties;
  final String flyInProgressProperty;
  final String attribute;
  final String label;

  FlyAttributeDropdown({
    this.flyProperties,
    this.attribute,
    this.label,
    this.flyInProgressProperty,
  });

  Widget _buildDropdown() {
    return FormBuilderDropdown(
      attribute: attribute,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: flyProperties.map<DropdownMenuItem<String>>((property) {
        return DropdownMenuItem<String>(
          value: property,
          child: Text(
            property,
          ),
        );
      }).toList(),
      validators: [FormBuilderValidators.required()],
    );
  }

  Widget _buildPrepopulatedDropdown() {
    return FormBuilderDropdown(
      attribute: attribute,
      decoration: InputDecoration(
        labelText: label,
      ),
      initialValue: flyInProgressProperty,
      items: flyProperties.map<DropdownMenuItem<String>>((property) {
        return DropdownMenuItem<String>(
          value: property,
          child: Text(
            property,
          ),
        );
      }).toList(),
      validators: [FormBuilderValidators.required()],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (flyProperties != null && flyInProgressProperty != null) {
      child = _buildPrepopulatedDropdown();
    } else {
      child = _buildDropdown();
    }
    return FieldLongPressWrapper(
      wrapperType: AddPropertyType.Attribute,
      properties: flyProperties,
      label: label,
      child: child,
      context: context,
    );
  }
}
