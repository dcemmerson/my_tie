import 'package:flutter/material.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/fly_exhibit_bloc.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';

typedef BuildPage = Widget Function(FlyExhibit);

class FlyExhibitDetailStreamBuilder extends StatelessWidget {
  final String docId;

  // Must pass in flyExhibitBloc so we can call the getFlyExhibit(docId) on the
  // correct FlyExhibitBloc subclass.
  final FlyExhibitBloc flyExhibitBloc;

  final BuildPage builder;

  FlyExhibitDetailStreamBuilder({
    @required this.docId,
    @required this.flyExhibitBloc,
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
        stream: flyExhibitBloc.getFlyExhibit(docId),
        // ignore: missing_return
        builder: (context, AsyncSnapshot<FlyExhibit> snapshot) {
          print(snapshot.connectionState);
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
