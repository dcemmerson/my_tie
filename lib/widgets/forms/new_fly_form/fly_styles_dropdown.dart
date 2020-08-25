import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly_style.dart';

class FlyStylesDropdown extends StatelessWidget {
  // final _underlineSuccess = Container(height: 2, color: AppColors.success);
  // final _underlineError = Container(height: 2, color: AppColors.error);

  final List<String> flyStyles;

  FlyStylesDropdown({this.flyStyles});

  Widget _buildDropdown() {
    return FormBuilderDropdown(
      attribute: 'flyStyle',
      decoration: const InputDecoration(
        labelText: 'Style',
      ),
      items: flyStyles.map<DropdownMenuItem<FlyStyles>>((style) {
        return DropdownMenuItem<FlyStyles>(
          value: FlyStyle.toEnum(style),
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
      attribute: 'flyStyle',
      decoration: const InputDecoration(
        labelText: 'Style',
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
    print('building');
    print(flyStyles);
    if (flyStyles != null) {
      return _buildDropdown();
    } else {
      return _buildLoading();
    }
  }
}
