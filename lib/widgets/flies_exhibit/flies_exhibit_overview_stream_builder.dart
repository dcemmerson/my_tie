import 'package:flutter/material.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';

typedef BuildPage = Widget Function(List<FlyExhibit>);

class FliesExhibitOverviewStreamBuilder extends StatelessWidget {
  final BuildPage builder;
  final Stream<List<FlyExhibit>> stream;

  FliesExhibitOverviewStreamBuilder({this.builder, this.stream});

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
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
