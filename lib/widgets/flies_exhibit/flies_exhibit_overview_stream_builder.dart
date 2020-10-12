import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';

typedef BuildPage = Widget Function(List<FlyExhibit>);

class FliesExhibitOverviewStreamBuilder extends StatelessWidget {
  final BuildPage builder;

  FliesExhibitOverviewStreamBuilder({this.builder});

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
            .flyExhibitBloc
            .newestFliesStream,
        builder: (context, AsyncSnapshot<List<FlyExhibit>> snapshot) {
          print(snapshot.connectionState);
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('error occurred');
          }
          switch (snapshot.connectionState) {
            case (ConnectionState.done):
            case (ConnectionState.active):
              return builder(snapshot.data);
            case (ConnectionState.none):
            case (ConnectionState.waiting):
            default:
              return _buildLoading();
          }
        });
  }
}
