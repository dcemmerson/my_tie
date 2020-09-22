import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';

typedef BuildPage = Widget Function(UserMaterialsTransfer);

class ProfileOverviewStreamBuilder extends StatelessWidget {
  final BuildPage child;
  ProfileOverviewStreamBuilder({this.child});

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: MyTieStateContainer.of(context)
            .blocProvider
            .userBloc
            .userMaterialsProfile,
        builder: (context, AsyncSnapshot<UserMaterialsTransfer> snapshot) {
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
