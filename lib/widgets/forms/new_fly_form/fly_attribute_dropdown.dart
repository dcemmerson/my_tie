import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    if (flyProperties != null && flyInProgressProperty != null) {
      return _buildPrepopulatedDropdown();
    } else {
      return _buildDropdown();
    }
  }
}
