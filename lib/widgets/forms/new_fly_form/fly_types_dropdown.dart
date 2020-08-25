import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly_type.dart';

class FlyTypesDropdown extends StatelessWidget {
  final List<String> flyTypes;
  FlyTypesDropdown({this.flyTypes});

  Widget _buildDropdown() {
    return FormBuilderDropdown(
      attribute: 'flyType',
      decoration: const InputDecoration(
        labelText: 'Type',
      ),
      items: flyTypes.map<DropdownMenuItem<FlyTypes>>((style) {
        return DropdownMenuItem<FlyTypes>(
          value: FlyType.toEnum(style),
          child: Text(
            style,
          ),
        );
      }).toList(),
      validators: [FormBuilderValidators.required()],
    );
  }

  Widget _buildLoading() {
    return FormBuilderDropdown(
      attribute: 'flyType',
      decoration: const InputDecoration(
        labelText: 'Type',
      ),
      items: [
        DropdownMenuItem<String>(
            child: Center(
          child: CircularProgressIndicator(),
        ))
      ],
      validators: [FormBuilderValidators.required()],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (flyTypes != null) {
      return _buildDropdown();
    } else {
      return _buildLoading();
    }
  }
}
