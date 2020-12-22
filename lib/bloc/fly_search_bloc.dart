import 'dart:async';

import 'package:my_tie/misc/debounce.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:rxdart/subjects.dart';

/// filename: fly_search_bloc.dart
/// last modified: 12/13/2020
/// description: BLoC responsible for handling fly searches coming
///   from the UI. This class uses the debounce class when handling
///   user keyboard input events coming from UI to prevent excess
///   search result calls.

class FlySearchBloc {
  final filteredFliesStreamController =
      BehaviorSubject<List<FlyExhibit>>(seedValue: []);
  // StreamController<List<FlyExhibit>>.broadcast();

  final _searchTermStreamController = StreamController<String>();
  StreamSink<String> flySearchTermSink;

  final List<FlyExhibit> flyExhibits = [];

  // We pass in a list of the flies streams that are used for the fly exhibit
  // bloc part of the app.
  FlySearchBloc() {
    flySearchTermSink = _searchTermStreamController.sink;

    _searchTermStreamController.stream
        .listen(Debounce(Duration(milliseconds: 350), _handleSearches)());
  }

  void addFliesExhibits(List<FlyExhibit> fliesIncoming) {
    fliesIncoming.forEach((flyIncoming) {
      if (flyExhibits.length == 0 ||
          flyExhibits.firstWhere(
                  (flyExhibit) => flyExhibit.fly.docId == flyIncoming.fly.docId,
                  orElse: () => null) ==
              null) {
        flyExhibits.add(flyIncoming);
      }
    });
  }

  void _handleSearches(String searchTerm) {
    if (searchTerm.length > 0) {
      final filteredFlyExhibits = flyExhibits
          .where((flyExhibit) => flyExhibit.containsTerm(searchTerm))
          .toList();
      filteredFliesStreamController.add(filteredFlyExhibits);
    } else {}
  }

  void close() {
    _searchTermStreamController.close();
    flySearchTermSink.close();
  }
}
