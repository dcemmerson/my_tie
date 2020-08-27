import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_attribute.dart';
import 'package:my_tie/models/fly_material.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/services/network/auth_service.dart';

import 'package:my_tie/services/network/new_fly_service.dart';

class NewFlyBloc {
  final NewFlyService newFlyService;
  final AuthService authService;

  // Coming from app.
  StreamController<List<FlyAttribute>> newFlyAttributesSink =
      StreamController<List<FlyAttribute>>();
  StreamController<FlyMaterial> newFlyMaterialsSink =
      StreamController<FlyMaterial>();

  // Going to app.
  StreamController<NewFlyFormTransfer> _flyFormMaterialTransfer =
      StreamController<NewFlyFormTransfer>.broadcast();

  NewFlyBloc({this.newFlyService, this.authService}) {
    newFlyAttributesSink.stream.listen(_handleAddNewFlyAttributes);
    newFlyMaterialsSink.stream.listen(_handleAddNewFlyMaterials);
  }

  Future<Fly> get _flyInProgress async {
    DocumentSnapshot snapshot =
        await newFlyService.getFlyInProgressDoc(authService.currentUser.uid);

    if (snapshot == null)
      return Fly();
    else
      return Fly(); //Fly(attributes: FlyAttribute.fromDoc(snapshot?.data()));
  }

  Future<NewFlyFormTemplate> get _newFlyFormTemplate async {
    DocumentSnapshot snapshot = await newFlyService.newFlyForm;
    return NewFlyFormTemplate.fromDoc(snapshot.data());
  }

  Stream<NewFlyFormTransfer> get newFlyForm {
    Future<NewFlyFormTemplate> fftm = _newFlyFormTemplate;
    Future<Fly> fly = _flyInProgress;

    Future.wait([fftm, fly]).then((List f) {
      _flyFormMaterialTransfer.add(
          NewFlyFormTransfer(newFlyFormTemplate: f[0], flyInProgress: f[1]));
    });

    return _flyFormMaterialTransfer.stream;
  }

  Future _handleAddNewFlyMaterials(FlyMaterial material) async {
    QueryDocumentSnapshot document =
        await newFlyService.getFlyInProgressDoc(authService.currentUser.uid);
    // print(material);
    // return;
    // if (document == null) {
    //   return newFlyService.addNewFlyMaterialsInProgressDoc(
    //     uid: authService.currentUser.uid,
    //     name: item.name,
    //     difficulty: item.difficulty.toString(),
    //     type: item.type.toString(),
    //     style: item.style.toString(),
    //     target: item.target.toString(),
    //   );
    // } else {
    return newFlyService.updateFlyMaterialsInProgress(
      docId: document.id,
      name: material.name,
      properties: material.properties,
    );
    // }
  }

  Future _handleAddNewFlyAttributes(List<FlyAttribute> flyAttributes) async {
    QueryDocumentSnapshot document =
        await newFlyService.getFlyInProgressDoc(authService.currentUser.uid);

    Map<String, String> formAttributeData = {};
    flyAttributes.forEach((flyAttribute) =>
        formAttributeData = {...formAttributeData, ...flyAttribute.toMap()});

    if (document == null) {
      return newFlyService.addNewFlyAttributesDoc(
        uid: authService.currentUser.uid,
        attributes: formAttributeData,
      );
    } else {
      return newFlyService.updateFlyAttributes(
        docId: document.id,
        attributes: formAttributeData,
      );
    }
  }

  void close() {
//    _newFlyFormStreamController.close();
    newFlyAttributesSink.close();
    newFlyMaterialsSink.close();
  }
}
