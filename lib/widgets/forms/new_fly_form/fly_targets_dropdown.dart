import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly_target.dart';

class FlyTargetsDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NewFlyBloc _newFlyBloc =
        MyTieStateContainer.of(context).blocProvider.newFlyBloc;
    return FutureBuilder(
      future: _newFlyBloc.newFlyForm.firstWhere((data) => data.size > 0),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error in fly targets');

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List flyTargets = snapshot.data.documents[0].data()['fly_targets'];
            return FormBuilderDropdown(
              attribute: 'Target Fish',
              decoration: const InputDecoration(
                labelText: 'Target Fish',
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
