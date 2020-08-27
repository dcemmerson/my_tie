import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/models/fly_form_material.dart';
import 'package:my_tie/styles/styles.dart';

class FlyMaterialDropdown extends StatelessWidget {
  final FlyFormMaterial flyMaterials;
  final String flyInProgressProperty;

  FlyMaterialDropdown({
    this.flyMaterials,
    this.flyInProgressProperty,
  });

  List<Widget> _buildDropdown() {
    var dropdowns = List<Widget>();

    flyMaterials.properties.forEach((String material, List<String> values) {
      dropdowns.add(FormBuilderDropdown(
        allowClear: true,
        attribute: material,
        decoration: InputDecoration(
          labelText: material,
        ),
        items: values.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
      ));
    });

    return dropdowns;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(flyMaterials.name, style: AppTextStyles.dropdownLabel),
        ..._buildDropdown(),
      ],
    );
  }
}
