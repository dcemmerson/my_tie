import 'package:flutter/material.dart';
import 'package:my_tie/bloc/fly_search_bloc.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';

typedef BuildPage = Widget Function(List<FlyExhibit>);

class FlySearchResultsStreamBuilder extends StatelessWidget {
  // Must pass in flyExhibitBloc so we can call the getFlyExhibit(docId) on the
  // correct FlyExhibitBloc subclass.
  final FlySearchBloc flySearchBloc;

  final BuildPage builder;

  FlySearchResultsStreamBuilder({
    @required this.flySearchBloc,
    @required this.builder,
  });

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: flySearchBloc.filteredFliesStreamController.stream,
        // ignore: missing_return
        builder: (context, AsyncSnapshot<List<FlyExhibit>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('error occurred');
          }
          switch (snapshot.connectionState) {
            case (ConnectionState.done):
            case (ConnectionState.active):
              if (snapshot.hasData) {
                return builder(snapshot.data);
              }
              continue defaultCase;
            case (ConnectionState.none):
            case (ConnectionState.waiting):
            defaultCase:
            default:
              return _buildLoading();
          }
        });
  }
}
