import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_attributes.dart';
import 'package:my_tie/models/fly_form_material.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/services/network/auth_service.dart';

import 'package:my_tie/services/network/new_fly_service.dart';

class NewFlyBloc {
  final NewFlyService newFlyService;
  final AuthService authService;

  // Coming from app.
  StreamController<FlyAttributes> newFlyAttributesSink =
      StreamController<FlyAttributes>();

  // Going to app.
  StreamController<List<FlyFormMaterial>> _flyFormMaterials =
      StreamController<List<FlyFormMaterial>>.broadcast();
  StreamController<NewFlyFormTransfer> _flyFormMaterialTransfer =
      StreamController<NewFlyFormTransfer>.broadcast();

  // Coming from firebase.
  NewFlyBloc({this.newFlyService, this.authService}) {
    // newFlyService.newFlyForm.listen(
    //     (formTemplate) => _newFlyFormStreamController.add(formTemplate));

    newFlyAttributesSink.stream.listen(_handleAddNewFlyAttributes);

//    flyMaterialsSink.stream.listen(_handleFlyMaterialsSink);
  }

  void _handleFlyMaterialsSink(FlyFormMaterial l) {}

  Future<Fly> get flyInProgress async {
    DocumentSnapshot snapshot =
        await newFlyService.getFlyInProgressDoc(authService.currentUser.uid);

    if (snapshot == null)
      return Fly();
    else
      return Fly(attributes: FlyAttributes.fromDoc(snapshot?.data()));
  }

  Future<NewFlyFormTemplate> get newFlyForm async {
    DocumentSnapshot snapshot = await newFlyService.newFlyForm;
    return NewFlyFormTemplate.fromDoc(snapshot.data());
  }

  Stream<NewFlyFormTransfer> get flyFormMaterials {
    Future<NewFlyFormTemplate> fftm = newFlyForm;
    Future<Fly> fly = flyInProgress;

    Future.wait([fftm, fly]).then((List f) {
      _flyFormMaterialTransfer.add(
          NewFlyFormTransfer(newFlyFormTemplate: f[0], flyInProgress: f[1]));
    });

    return _flyFormMaterialTransfer.stream;
  }

  Future _handleAddNewFlyAttributes(FlyAttributes item) async {
    QueryDocumentSnapshot document =
        await newFlyService.getFlyInProgressDoc(authService.currentUser.uid);
    if (document == null) {
      return newFlyService.addNewFlyAttributesDoc(
        uid: authService.currentUser.uid,
        name: item.name,
        difficulty: item.difficulty.toString(),
        type: item.type.toString(),
        style: item.style.toString(),
        target: item.target.toString(),
      );
    } else {
      return newFlyService.updateFlyAttributes(
        docId: document.id,
        name: item.name,
        difficulty: item.difficulty.toString(),
        type: item.type.toString(),
        style: item.style.toString(),
        target: item.target.toString(),
      );
    }
  }

  void close() {
//    _newFlyFormStreamController.close();
    newFlyAttributesSink.close();
  }
}
