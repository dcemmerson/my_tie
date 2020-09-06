/// filename: new_fly_bloc.dart
/// last modified: 09/03/2020
/// description: New fly BLoC class. Business logic class for user adding a new
///   fly to database. This class stands between the = app (the actual new fly
///   forms, and service to firestore, in new_fly_serverice.dart). This class
///   provides our app with streams and sinks to read, add, remove, etc
///   data from firestore.

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/arguments/instruction_page_attribute.dart';
import 'package:my_tie/models/bloc_related/fly_instruction_change.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_instruction.dart';
import 'package:my_tie/models/fly_materials.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import 'package:my_tie/services/network/new_fly_service.dart';
import 'package:rxdart/rxdart.dart';

import 'stream_transformers/document_to_fly_instruction.dart';

class NewFlyBloc {
  final NewFlyService newFlyService;
  final AuthService authService;
  final FlyFormTemplateService flyFormTemplateService;

  // Coming from app.
  StreamController<Fly> newFlyAttributesSink = StreamController<Fly>();
  StreamController<FlyMaterialAddOrUpdate> newFlyMaterialSink =
      StreamController<FlyMaterialAddOrUpdate>();
  StreamController<FlyInstructionChange> newFlyInstructionSink =
      StreamController<FlyInstructionChange>();
  StreamController<FlyInstruction> deleteFlyInstructionSink =
      StreamController<FlyInstruction>();
  StreamController<FlyMaterial> deleteFlyMaterialSink =
      StreamController<FlyMaterial>();

  NewFlyBloc(
      {this.newFlyService, this.authService, this.flyFormTemplateService}) {
    newFlyAttributesSink.stream.listen(_handleAddNewFlyAttributes);
    newFlyMaterialSink.stream.listen(_handleAddNewFlyMaterial);
    newFlyInstructionSink.stream.listen(_handleAddNewFlyInstruction);
    deleteFlyMaterialSink.stream.listen(_handleDeleteFlyMaterial);
  }

  Stream<NewFlyFormTransfer> get newFlyForm {
    Stream<QuerySnapshot> flyInProgressStream =
        newFlyService.getFlyInProgressDocStream(authService.currentUser.uid);
    Stream<QuerySnapshot> flyTemplateDocStream =
        flyFormTemplateService.newFlyFormStream;

    return CombineLatestStream.combine2(
      flyInProgressStream,
      flyTemplateDocStream,
      (QuerySnapshot flyInProgressDoc, QuerySnapshot nfftDocs) {
        NewFlyFormTemplate newFlyFormTemplate =
            NewFlyFormTemplate.fromDoc(nfftDocs?.docs[0]?.data());

        // flyInProgressDocs.docs could be empty here here, first time user
        //  click addNewFly button.
        Fly flyInProgress = flyInProgressDoc?.docs[0]?.data() != null
            ? Fly.formattedForEditing(
                docId: flyInProgressDoc?.docs[0].id,
                flyName: flyInProgressDoc?.docs[0]?.data()[DbNames.flyName],
                attrs: flyInProgressDoc?.docs[0]?.data()[DbNames.attributes],
                mats: flyInProgressDoc?.docs[0]?.data()[DbNames.materials],
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
    Stream<QuerySnapshot> flyInProgressStream =
        newFlyService.getFlyInProgressDocStream(authService.currentUser.uid);

    Stream<QuerySnapshot> flyTemplateDocStream =
        flyFormTemplateService.newFlyFormStream;

    return CombineLatestStream.combine2(
      flyInProgressStream,
      flyTemplateDocStream,
      (QuerySnapshot flyInProgressDoc, QuerySnapshot nfftDocs) {
        NewFlyFormTemplate newFlyFormTemplate =
            NewFlyFormTemplate.fromDoc(nfftDocs?.docs[0]?.data());

        Fly flyInProgress = Fly.formattedForReview(
          docId: flyInProgressDoc?.docs[0].id,
          flyName: flyInProgressDoc?.docs[0]?.data()[DbNames.flyName],
          attrs: flyInProgressDoc?.docs[0]?.data()[DbNames.attributes],
          mats: flyInProgressDoc?.docs[0]?.data()[DbNames.materials],
          instr: flyInProgressDoc?.docs[0]?.data()[DbNames.instructions],
          flyFormTemplate: newFlyFormTemplate,
        );

        return NewFlyFormTransfer(
          flyInProgress: flyInProgress,
          newFlyFormTemplate: newFlyFormTemplate,
        );
      },
    );
  }

  Stream<FlyInstruction> getFlyInProgressInstructionStep(
      InstructionPageAttribute ipa) {
    return newFlyService
        .getFlyInProgressDocStream(authService.currentUser.uid)
        .transform(DocumentToFlyInstruction(ipa.stepNumber));
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

  Future _handleAddNewFlyInstruction(
      FlyInstructionChange instructionChange) async {
    // Add new files that user took with camera (or selected on device) to
    //  Firebase storage.
    List<String> addedUris = await newFlyService.addFilesToStorage(
      uid: authService.currentUser.uid,
      images: instructionChange.imagesToAdd,
    );

    //  Now update the actual fly instructions doc
    return newFlyService.addNewFlyInstruction(
      uid: authService.currentUser.uid,
      title: instructionChange.title,
      description: instructionChange.description,
      stepNumber: instructionChange.step,
      imageUris: [...addedUris, ...instructionChange.imageUrisToKeep],
    );
    //  We do not burden the client with correctly merging the old instruction
    //  step with the new instruction step. Instead, we have a cloud funciton
    //  performing this task for us.

    //  Finally delete any previous images user may have uploaded for this step
    //  but is no longer using for this instruction step.
    // Future deleteUnusedImages = newFlyService.deleteFilesInStorage(
    //     uid: authService.currentUser.uid,
    //     imageUris: instructionChange.imageUrisToDelete);

    // return Future.wait([updateInstructions, deleteUnusedImages])
    //     .catchError((err) => print(err));
  }

  void close() {
    newFlyAttributesSink.close();
    newFlyMaterialSink.close();
    deleteFlyMaterialSink.close();
    newFlyInstructionSink.close();
    deleteFlyInstructionSink.close();
  }
}

class FlyMaterialAddOrUpdate {
  final FlyMaterial prev;
  final FlyMaterial curr;

  FlyMaterialAddOrUpdate({this.prev, this.curr});
}
