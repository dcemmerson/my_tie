import 'dart:async';

import 'package:my_tie/misc/debounce.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';

/// filename: fly_search_bloc.dart
/// last modified: 12/13/2020
/// description: BLoC responsible for handling fly searches coming
///   from the UI. This class uses the debounce class when handling
///   user keyboard input events coming from UI to prevent excess
///   search result calls.

class FlySearchBloc {
  final flySearchSink = StreamController<String>();

  FlySearchBloc() {
    flySearchSink.stream
        .listen(Debounce(Duration(milliseconds: 350), _handleSearches)());
  }

  void _handleSearches(String searchTerm) {
    print(searchTerm);
  }

  void close() {
    flySearchSink.close();
  }
}
