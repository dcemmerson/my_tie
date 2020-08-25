import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly_target.dart';

class FlyTargetsDropdown extends StatelessWidget {
  final List<String> flyTargets;
  FlyTargetsDropdown({this.flyTargets});

  Widget _buildDropdown() {
    return FormBuilderDropdown(
      attribute: 'flyTarget',
      decoration: const InputDecoration(
        labelText: 'Target',
      ),
      items: flyTargets.map<DropdownMenuItem<FlyTargets>>((target) {
        return DropdownMenuItem<FlyTargets>(
          value: FlyTarget.toEnum(target),
          child: Text(
            target,
          ),
        );
      }).toList(),
      validators: [FormBuilderValidators.required()],
    );
  }

  Widget _buildLoading() {
    return FormBuilderDropdown(
      attribute: 'flyTarget',
      decoration: const InputDecoration(
        labelText: 'Target',
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
    if (flyTargets != null) {
      return _buildDropdown();
    } else {
      return _buildLoading();
    }
  }
}
