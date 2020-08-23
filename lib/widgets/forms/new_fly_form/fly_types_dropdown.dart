import 'package:flutter/material.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';

enum FlyType { Dry, Wet, Nymph, Emerger, Other }

class FlyTypesDropdown extends StatefulWidget {
  @override
  _FlyTypesDropdownState createState() => _FlyTypesDropdownState();
}

class _FlyTypesDropdownState extends State<FlyTypesDropdown> {
  NewFlyBloc _newFlyBloc;
  FlyType _selectedFlyType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;
  }

  FlyType _getFlyType(String type) {
    switch (type) {
      case ('dry_fly'):
        return FlyType.Dry;
      case ('wet_fly'):
        return FlyType.Wet;
      case ('nymph'):
        return FlyType.Nymph;
      case ('emerger'):
        return FlyType.Emerger;
      default:
        return FlyType.Other;
    }
  }

  void _flyTypeSelected(FlyType flyType) =>
      setState(() => _selectedFlyType = flyType);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _newFlyBloc.flyTypes.firstWhere((data) => data.size > 0),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error in fly types');

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List flyTypes = snapshot.data.documents[0].data()['fly_types'];

            return DropdownButton<FlyType>(
              value: _selectedFlyType ?? FlyType.Dry,
              items: flyTypes.map<DropdownMenuItem<FlyType>>((type) {
                return DropdownMenuItem<FlyType>(
                  value: _getFlyType(type),
                  child: Text(
                    type,
                  ),
                );
              }).toList(),
              onChanged: _flyTypeSelected,
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
