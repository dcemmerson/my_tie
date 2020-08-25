import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:my_tie/models/fly_difficulty.dart';

class FlyDifficultyDropdown extends StatelessWidget {
  // final _underlineSuccess = Container(height: 2, color: AppColors.success);
  // final _underlineError = Container(height: 2, color: AppColors.error);
  final List<String> flyDifficulties;
  FlyDifficultyDropdown({this.flyDifficulties});

  Widget _buildDropdown() {
    return FormBuilderDropdown(
      attribute: 'flyDifficulty',
      decoration: const InputDecoration(
        labelText: 'Difficulty',
      ),
      items: flyDifficulties.map<DropdownMenuItem<FlyDifficulties>>((style) {
        return DropdownMenuItem<FlyDifficulties>(
          value: FlyDifficulty.toEnum(style),
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
      attribute: 'flyDifficulty',
      decoration: const InputDecoration(
        labelText: 'Difficulty',
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
    if (flyDifficulties != null) {
      return _buildDropdown();
    } else {
      return _buildLoading();
    }
  }
}
