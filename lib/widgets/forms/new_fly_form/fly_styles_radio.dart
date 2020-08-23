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

class FlyStylesRadio extends StatefulWidget {
  @override
  _FlyStylesRadioState createState() => _FlyStylesRadioState();
}

class _FlyStylesRadioState extends State<FlyStylesRadio> {
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

  void _flyTypeSelected(FlyStyle flyStype) =>
      setState(() => _selectedFlyStyle = flyStype);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _newFlyBloc.flyTypes.firstWhere((data) => data.size > 0),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error in fly types');

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List flyTypes = snapshot.data.documents[0].data()['fly_types'];

            return Radio<FlyStyle>(
              value: _selectedFlyStyle ?? FlyStyle.Other,
              items: flyTypes.map<Radio<FlyStyle>>((type) {
                return Radio<FlyStyle>(
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
