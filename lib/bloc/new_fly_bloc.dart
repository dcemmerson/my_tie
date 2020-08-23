import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_tie/services/network/new_fly_service.dart';
import 'package:rxdart/rxdart.dart';

class NewFlyBloc {
  final NewFlyService _newFlyService;

  // Coming from firebase.
  Stream<QuerySnapshot> get difficulties =>
      _difficultiesStreamController.stream;
  StreamController<QuerySnapshot> _difficultiesStreamController =
      BehaviorSubject<QuerySnapshot>(seedValue: null);

  Stream<QuerySnapshot> get flyStyles => _flyStylesStreamController.stream;
  StreamController<QuerySnapshot> _flyStylesStreamController =
      BehaviorSubject<QuerySnapshot>(seedValue: null);

  Stream<QuerySnapshot> get flyTypes => _flyTypesStreamController.stream;
  StreamController<QuerySnapshot> _flyTypesStreamController =
      BehaviorSubject<QuerySnapshot>(seedValue: null);

  Stream<QuerySnapshot> get flyMaterials => _flyTypesStreamController.stream;
  StreamController<QuerySnapshot> _flyMaterialsStreamController =
      BehaviorSubject<QuerySnapshot>(seedValue: null);

  NewFlyBloc(this._newFlyService) {
    _newFlyService.difficulties.listen(
        (difficulties) => _difficultiesStreamController.add(difficulties));
    _newFlyService.flyStyles
        .listen((flyStyles) => _flyStylesStreamController.add(flyStyles));
    _newFlyService.flyTypes
        .listen((flyTypes) => _flyTypesStreamController.add(flyTypes));
    _newFlyService.flyMaterials.listen(
        (flyMaterials) => _flyMaterialsStreamController.add(flyMaterials));
  }

  close() {
    _difficultiesStreamController.close();
    _flyStylesStreamController.close();
    _flyTypesStreamController.close();
    _flyMaterialsStreamController.close();
  }
}
