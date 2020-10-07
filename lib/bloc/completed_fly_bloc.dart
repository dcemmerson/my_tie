import 'dart:async';

import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/services/network/completed_fly_service.dart';
import 'package:rxdart/subjects.dart';

class CompletedFlyBloc {
  CompletedFlyService completedFlyService;

  final List<Fly> newestFlies = [];

  final _requestFetchFlies = StreamController<FetchFliesEvent>();
  StreamSink<FetchFliesEvent> requestFetchFliesSink;

  StreamController<List<Fly>> _newestFliesStreamController;
  Stream<List<Fly>> newestFliesStream;

  CompletedFlyBloc({this.completedFlyService}) {
    _newestFliesStreamController =
        BehaviorSubject<List<Fly>>(seedValue: newestFlies);
    requestFetchFliesSink = _requestFetchFlies.sink;
    newestFliesStream = _newestFliesStreamController.stream;
    _requestFetchFlies.stream.listen((ffe) {
      if (ffe is FetchRandomFliesEvent) {
        print('fetch random flies');
      } else {
        print('event not found');
      }
    });
  }

  void close() {
    _requestFetchFlies.close();
    requestFetchFliesSink.close();
    _newestFliesStreamController.close();
  }
}

class FetchFliesEvent {}

class FetchRandomFliesEvent extends FetchFliesEvent {}
