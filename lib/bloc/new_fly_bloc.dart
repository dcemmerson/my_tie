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
import 'package:my_tie/models/fly_materials.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import 'package:my_tie/services/network/new_fly_service.dart';
import 'package:rxdart/rxdart.dart';

class NewFlyBloc {
  final NewFlyService newFlyService;
  final AuthService authService;
  final FlyFormTemplateService flyFormTemplateService;

  // Coming from app.
  StreamController<Fly> newFlyAttributesSink = StreamController<Fly>();
  StreamController<FlyMaterialAddOrUpdate> newFlyMaterialSink =
      StreamController<FlyMaterialAddOrUpdate>();
  StreamController<FlyMaterial> deleteFlyMaterialSink =
      StreamController<FlyMaterial>();

  // Going to app.
  NewFlyBloc(
      {this.newFlyService, this.authService, this.flyFormTemplateService}) {
    newFlyAttributesSink.stream.listen(_handleAddNewFlyAttributes);
    newFlyMaterialSink.stream.listen(_handleAddNewFlyMaterial);
    deleteFlyMaterialSink.stream.listen(_handleDeleteFlyMaterial);
  }

  Stream<NewFlyFormTransfer> get newFlyForm {
    Stream<DocumentSnapshot> flyInProgressStream =
        newFlyService.getFlyInProgressDocStream(authService.currentUser.uid);
    Stream<QuerySnapshot> flyTemplateDocStream =
        flyFormTemplateService.newFlyFormStream;

    return CombineLatestStream.combine2(
      flyInProgressStream,
      flyTemplateDocStream,
      (DocumentSnapshot flyInProgressDoc, QuerySnapshot nfftDocs) {
        NewFlyFormTemplate newFlyFormTemplate =
            NewFlyFormTemplate.fromDoc(nfftDocs?.docs[0]?.data());

        // flyInProgressDocs.docs could be empty here here, first time user
        //  click addNewFly button.
        Fly flyInProgress = flyInProgressDoc?.data() != null
            ? Fly.formattedForEditing(
                flyName: flyInProgressDoc?.data()[DbNames.flyName],
                attrs: flyInProgressDoc?.data()[DbNames.attributes],
                mats: flyInProgressDoc?.data()[DbNames.materials],
                flyFormTemplate: newFlyFormTemplate)
            : Fly.formattedForEditing(flyFormTemplate: newFlyFormTemplate);

        return NewFlyFormTransfer(
          flyInProgress: flyInProgress,
          newFlyFormTemplate: newFlyFormTemplate,
        );
      },
    );
  }

  Stream<NewFlyFormTransfer> get newFlyFormReview {
    Stream<DocumentSnapshot> flyInProgressStream =
        newFlyService.getFlyInProgressDocStream(authService.currentUser.uid);
    Stream<QuerySnapshot> flyTemplateDocStream =
        flyFormTemplateService.newFlyFormStream;

    return CombineLatestStream.combine2(
      flyInProgressStream,
      flyTemplateDocStream,
      (DocumentSnapshot flyInProgressDoc, QuerySnapshot nfftDocs) {
        NewFlyFormTemplate newFlyFormTemplate =
            NewFlyFormTemplate.fromDoc(nfftDocs?.docs[0]?.data());

        Fly flyInProgress = Fly.formattedForReview(
            flyName: flyInProgressDoc?.data()[DbNames.flyName],
            attrs: flyInProgressDoc?.data()[DbNames.attributes],
            mats: flyInProgressDoc?.data()[DbNames.materials],
            flyFormTemplate: newFlyFormTemplate);

        return NewFlyFormTransfer(
          flyInProgress: flyInProgress,
          newFlyFormTemplate: newFlyFormTemplate,
        );
      },
    );
  }

  Future _handleDeleteFlyMaterial(FlyMaterial flyMaterial) async {
    if (flyMaterial != null) {
      return newFlyService.deleteFlyInProgressMaterial(
        uid: authService.currentUser.uid,
        name: flyMaterial.name,
        properties: flyMaterial.properties,
      );
    }
  }

  Future _handleAddNewFlyMaterial(FlyMaterialAddOrUpdate materialUpdate) async {
    // Add new material to array, then delete the old material since firestore
    //  doesn't have good support for update array.
    newFlyService.addFlyInProgressMaterial(
      uid: authService.currentUser.uid,
      name: materialUpdate.curr.name,
      properties: materialUpdate.curr.properties,
    );
    return _handleDeleteFlyMaterial(materialUpdate.prev);
  }

  Future _handleAddNewFlyAttributes(Fly flyInProgress) async {
    Map<String, String> formAttributeData = {};
    flyInProgress.attributes.forEach((flyAttribute) =>
        formAttributeData = {...formAttributeData, ...flyAttribute.toMap()});

    return newFlyService.addNewFlyAttributes(
      uid: authService.currentUser.uid,
      flyName: flyInProgress.flyName,
      attributes: formAttributeData,
    );
  }

  void close() {
    newFlyAttributesSink.close();
    newFlyMaterialSink.close();
  }
}

class FlyMaterialAddOrUpdate {
  final FlyMaterial prev;
  final FlyMaterial curr;

  FlyMaterialAddOrUpdate({this.prev, this.curr});
}
