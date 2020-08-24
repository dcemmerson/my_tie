import 'package:flutter/material.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';

enum FlyStyle {
  Midge,
  Caddis,
  Mayfly,
  Streamer,
  Terrestrial,
  Egg,
  Attractor,
  Foam,
  Other,
}

class FlyStylesDropdown extends StatefulWidget {
  @override
  _FlyStylesDropdownState createState() => _FlyStylesDropdownState();
}

class _FlyStylesDropdownState extends State<FlyStylesDropdown> {
  NewFlyBloc _newFlyBloc;
  FlyStyle _selectedFlyStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;
  }

  FlyStyle _getFlyType(String type) {
    switch (type) {
      case ('midge'):
        return FlyStyle.Midge;
      case ('caddis'):
        return FlyStyle.Caddis;
      case ('mayfly'):
        return FlyStyle.Mayfly;
      case ('streamer'):
        return FlyStyle.Streamer;
      case ('terrestrial'):
        return FlyStyle.Terrestrial;
      case ('egg'):
        return FlyStyle.Egg;
      case ('attractor'):
        return FlyStyle.Attractor;
      case ('foam'):
        return FlyStyle.Foam;
      default:
        return FlyStyle.Other;
    }
  }

  void _flyStyleSelected(FlyStyle flyStyle) =>
      setState(() => _selectedFlyStyle = flyStyle);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _newFlyBloc.newFlyForm.firstWhere((data) => data.size > 0),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error in fly styles');

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List flyStyles = snapshot.data.documents[0].data()['fly_styles'];
            return DropdownButton<FlyStyle>(
              value: _selectedFlyStyle ?? FlyStyle.Midge,
              items: flyStyles.map<DropdownMenuItem<FlyStyle>>((style) {
                return DropdownMenuItem<FlyStyle>(
                  value: _getFlyType(style),
                  child: Text(
                    style,
                  ),
                );
              }).toList(),
              onChanged: _flyStyleSelected,
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
