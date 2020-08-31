/// filename: new_fly_bloc.dart
/// last modified: 08/30/2020
/// description: New fly BLoC class. Business logic class for user adding a new
///   fly to database. This class stands between the = app (the actual new fly
///   forms, and service to firestore, in new_fly_serverice.dart). This class
///   provides our app with streams and sinks to read, add, remove, etc
///   data from firestore.

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_attribute.dart';
import 'package:my_tie/models/fly_material.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/services/network/auth_service.dart';

import 'package:my_tie/services/network/new_fly_service.dart';
import 'package:rxdart/rxdart.dart';

import 'stream_transformers/document_to_fly_form_template.dart';
import 'stream_transformers/document_to_fly_transformer.dart';

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
      return Fly(
          attrs: snapshot?.data()['attributes'],
          mats: snapshot?.data()['materials']);
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

  Stream<NewFlyFormTransfer> get newFlyFormStreams {
    Stream<QuerySnapshot> flyInProgress =
        newFlyService.getFlyInProgressDocStream(authService.currentUser.uid);
    Stream<DocumentSnapshot> flyTemplateDoc = newFlyService.newFlyFormStream;

    return CombineLatestStream.combine2(
      flyInProgress,
      flyTemplateDoc,
      (QuerySnapshot flyDoc, DocumentSnapshot nfftDoc) {
        return NewFlyFormTransfer(
          flyInProgress: Fly(
              attrs: flyDoc.docs[0]?.data()[DbNames.attributes],
              mats: flyDoc.docs[0]?.data()[DbNames.materials]),
          newFlyFormTemplate: NewFlyFormTemplate.fromDoc(nfftDoc.data()),
        );
      },
    );
  }

  Future _handleAddNewFlyMaterials(FlyMaterial material) async {
    QueryDocumentSnapshot document =
        await newFlyService.getFlyInProgressDoc(authService.currentUser.uid);

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
