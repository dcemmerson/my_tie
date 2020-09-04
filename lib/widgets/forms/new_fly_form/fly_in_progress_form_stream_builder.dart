import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';

typedef BuildPage = Widget Function(NewFlyFormTransfer);

class FlyInProgressFormStreamBuilder extends StatelessWidget {
  final BuildPage child;
  FlyInProgressFormStreamBuilder({this.child});

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            MyTieStateContainer.of(context).blocProvider.newFlyBloc.newFlyForm,
        builder: (context, AsyncSnapshot<NewFlyFormTransfer> snapshot) {
          print(snapshot.connectionState);
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('error occurred');
          }
          switch (snapshot.connectionState) {
            case (ConnectionState.done):
            case (ConnectionState.active):
              return child(snapshot.data);
            case (ConnectionState.none):
            case (ConnectionState.waiting):
            default:
              return _buildLoading();
          }
        });
  }
}
