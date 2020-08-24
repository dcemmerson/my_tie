import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_tie/services/network/new_fly_service.dart';
import 'package:rxdart/rxdart.dart';

class NewFlyBloc {
  final NewFlyService _newFlyService;

  // Coming from firebase.
  Stream<QuerySnapshot> get newFlyForm => _newFlyFormStreamController.stream;
  StreamController<QuerySnapshot> _newFlyFormStreamController =
      BehaviorSubject<QuerySnapshot>(seedValue: null);

  NewFlyBloc(this._newFlyService) {
    _newFlyService.newFlyForm
        .listen((form) => _newFlyFormStreamController.add(form));
  }

  close() {
    _newFlyFormStreamController.close();
  }
}
