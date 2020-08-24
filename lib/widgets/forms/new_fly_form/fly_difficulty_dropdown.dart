import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly_difficulty.dart';

class FlyDifficultyDropdown extends StatelessWidget {
  // final _underlineSuccess = Container(height: 2, color: AppColors.success);
  // final _underlineError = Container(height: 2, color: AppColors.error);

  @override
  Widget build(BuildContext context) {
    NewFlyBloc _newFlyBloc =
        MyTieStateContainer.of(context).blocProvider.newFlyBloc;
    return FutureBuilder(
      future: _newFlyBloc.newFlyForm.firstWhere((data) => data.size > 0),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error in fly styles');

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List flyStyles =
                snapshot.data.documents[0].data()['fly_difficulties'];
            return FormBuilderDropdown(
              attribute: 'Difficulty',
              decoration: const InputDecoration(
                labelText: 'Difficulty',
              ),
              items: flyStyles.map<DropdownMenuItem<FlyDifficulties>>((style) {
                return DropdownMenuItem<FlyDifficulties>(
                  value: FlyDifficulty.toEnum(style),
                  child: Text(
                    style,
                  ),
                );
              }).toList(),
              validators: [FormBuilderValidators.required()],
            );

          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
