import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/models/arguments/add_property_argument.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/form_page_number.dart';

import 'package:my_tie/styles/styles.dart';

import '../field_long_press_wrapper.dart';

class FlyMaterialDropdown extends StatelessWidget {
  final FlyFormMaterial flyMaterials;
  final Fly fly;
  final FormPageNumber formPageNumber;

  FlyMaterialDropdown({this.flyMaterials, this.fly, this.formPageNumber});

  List<Widget> _buildDropdown(BuildContext context) {
    List<Widget> dropdowns = [];

    flyMaterials.properties.forEach((String materialType, List<String> values) {
      final String initialValue = fly.getMaterial(formPageNumber.pageNumber,
          formPageNumber.propertyIndex, materialType);
      dropdowns.add(
        FieldLongPressWrapper(
          wrapperType: AddPropertyType.Material,
          properties: values,
          materialName: flyMaterials.name,
          label: materialType,
          context: context,
          child: FormBuilderDropdown(
            allowClear: true,
            attribute: materialType,
            initialValue: values.contains(initialValue) ? initialValue : null,
            decoration: InputDecoration(
              labelText: materialType,
            ),
            items: values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
          ),
        ),
      );
    });

    return dropdowns;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(flyMaterials.name, style: AppTextStyles.dropdownLabel),
        ..._buildDropdown(context),
      ],
    );
  }
}
