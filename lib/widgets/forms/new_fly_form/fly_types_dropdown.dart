import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly_type.dart';

class FlyTypesDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NewFlyBloc _newFlyBloc =
        MyTieStateContainer.of(context).blocProvider.newFlyBloc;

    return FutureBuilder(
      future: _newFlyBloc.newFlyForm.firstWhere((data) => data.size > 0),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error in fly types');

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List flyStyles = snapshot.data.documents[0].data()['fly_types'];
            return FormBuilderDropdown(
              attribute: 'type',
              decoration: const InputDecoration(
                labelText: 'Type',
              ),
              items: flyStyles.map<DropdownMenuItem<FlyTypes>>((style) {
                return DropdownMenuItem<FlyTypes>(
                  value: FlyType.toEnum(style),
                  child: Text(
                    style,
                  ),
                );
              }).toList(),
              onChanged: (val) => print(val),
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
