/// filename: new_fly_bloc.dart
/// last modified: 09/06/2020
/// description: New fly BLoC class. Business logic class for user adding a new
///   fly to database. This class stands between the = app (the actual new fly
///   forms, and service to firestore, in new_fly_serverice.dart). This class
///   provides our app with streams and sinks to read, add, remove, etc
///   data from firestore.

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/arguments/instruction_page_attribute.dart';
import 'package:my_tie/models/bloc_transfer_related/fly_attribute_change.dart';
import 'package:my_tie/models/bloc_transfer_related/fly_instruction_change.dart';
import 'package:my_tie/models/bloc_transfer_related/fly_instruction_transfer.dart';
import 'package:my_tie/models/bloc_transfer_related/fly_material_add_or_update.dart';

import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';
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
  StreamController<FlyAttributeChange> newFlyAttributesSink =
      StreamController<FlyAttributeChange>();
  StreamController<FlyMaterialAddOrUpdate> newFlyMaterialSink =
      StreamController<FlyMaterialAddOrUpdate>();
  StreamController<FlyInstructionChange> newFlyInstructionSink =
      StreamController<FlyInstructionChange>();
  StreamController<FlyInstructionTransfer> deleteFlyInstructionSink =
      StreamController<FlyInstructionTransfer>();
  StreamController<FlyMaterialAddOrUpdate> deleteFlyMaterialSink =
      StreamController<FlyMaterialAddOrUpdate>();
  StreamController<Fly> deleteFlyInProgressSink = StreamController<Fly>();

  NewFlyBloc(
      {this.newFlyService, this.authService, this.flyFormTemplateService}) {
    newFlyAttributesSink.stream.listen(_handleAddNewFlyAttributes);
    newFlyMaterialSink.stream.listen(_handleAddNewFlyMaterial);
    newFlyInstructionSink.stream.listen(_handleAddNewFlyInstruction);
    deleteFlyMaterialSink.stream.listen(_handleDeleteFlyMaterial);
    deleteFlyInstructionSink.stream.listen(_handleDeleteFlyInstruction);
    deleteFlyInProgressSink.stream.listen(_handleDeleteFlyInProgress);
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

        Fly flyInProgress;

        if (flyInProgressDoc?.docs != null &&
            flyInProgressDoc.docs.length > 0) {
          flyInProgress = Fly.formattedForEditing(
              docId: flyInProgressDoc?.docs[0].id,
              flyName: flyInProgressDoc?.docs[0]?.data()[DbNames.flyName],
              flyDescription:
                  flyInProgressDoc?.docs[0]?.data()[DbNames.flyDescription],
              attrs: flyInProgressDoc?.docs[0]?.data()[DbNames.attributes],
              mats: flyInProgressDoc?.docs[0]?.data()[DbNames.materials],
              instr: flyInProgressDoc?.docs[0]?.data()[DbNames.instructions],
              imageUris:
                  flyInProgressDoc?.docs[0]?.data()[DbNames.topLevelImageUris],
              flyFormTemplate: newFlyFormTemplate);
        } else {
          newFlyService.createFlyInProgressDoc(
              uid: authService.currentUser.uid);
          flyInProgress =
              Fly.formattedForEditing(flyFormTemplate: newFlyFormTemplate);
        }
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

        Fly flyInProgress;
        if (flyInProgressDoc.docs.length == 0) {
          newFlyService.createFlyInProgressDoc(
              uid: authService.currentUser.uid);
          flyInProgress =
              Fly.formattedForReview(flyFormTemplate: newFlyFormTemplate);
        } else {
          flyInProgress = Fly.formattedForReview(
            docId: flyInProgressDoc?.docs[0]?.id,
            flyName: flyInProgressDoc?.docs[0]?.data()[DbNames.flyName],
            flyDescription:
                flyInProgressDoc?.docs[0]?.data()[DbNames.flyDescription],
            attrs: flyInProgressDoc?.docs[0]?.data()[DbNames.attributes],
            mats: flyInProgressDoc?.docs[0]?.data()[DbNames.materials],
            instr: flyInProgressDoc?.docs[0]?.data()[DbNames.instructions],
            imageUris:
                flyInProgressDoc?.docs[0]?.data()[DbNames.topLevelImageUris],
            flyFormTemplate: newFlyFormTemplate,
          );
        }

        return NewFlyFormTransfer(
          flyInProgress: flyInProgress,
          newFlyFormTemplate: newFlyFormTemplate,
        );
      },
    );
  }

  Stream<FlyInstructionTransfer> getFlyInProgressInstructionStep(
      InstructionPageAttribute ipa) {
    return newFlyService
        .getFlyInProgressDocStream(authService.currentUser.uid)
        .transform(DocumentToFlyInstruction(ipa.stepNumber));
  }

  Future _handleDeleteFlyMaterial(FlyMaterialAddOrUpdate materialUpdate) async {
    if (materialUpdate.prev != null) {
      return newFlyService.deleteFlyInProgressMaterial(
        docId: materialUpdate.fly.docId,
        name: materialUpdate.prev.name,
        properties: materialUpdate.prev.properties,
      );
    }
  }

  Future _handleDeleteFlyInstruction(
      FlyInstructionTransfer instructionTransfer) {
    return newFlyService.updateFlyInProgressInstructions(
      docId: instructionTransfer.fly.docId,
      uid: authService.currentUser.uid,
      instructions:
          instructionTransfer.getMergedInstructionsMapSortedAfterRemoval(),
    );
  }

  Future _handleAddNewFlyMaterial(FlyMaterialAddOrUpdate materialUpdate) async {
    // Add new material to array, then delete the old material since firestore
    //  doesn't currently have good support for update array.
    newFlyService.addFlyInProgressMaterial(
      docId: materialUpdate.fly.docId,
      uid: authService.currentUser.uid,
      name: materialUpdate.curr.name,
      properties: materialUpdate.curr.properties,
    );
    return _handleDeleteFlyMaterial(materialUpdate);
  }

  Future _handleAddNewFlyAttributes(
      FlyAttributeChange flyAttributeChange) async {
    //  Add file uris to storage.
    Future<List<String>> addedUris = newFlyService.addFilesToStorage(
      uid: authService.currentUser.uid,
      images: flyAttributeChange.imagesToAdd,
    );

    //  Collect form attributes.
    Map<String, String> formAttributeData = {};
    flyAttributeChange.updatedAttributes.forEach((flyAttribute) =>
        formAttributeData = {...formAttributeData, ...flyAttribute.toMap()});

    //  Now add attributes to firestore without newly added photo urls.
    newFlyService.addNewFlyAttributes(
      docId: flyAttributeChange.prevFly.docId,
      uid: authService.currentUser.uid,
      flyName: flyAttributeChange.updatedAttributes
          .firstWhere((attr) => attr.name == DbNames.flyName)
          .value,
      attributes: formAttributeData,
      topLevelImageUris: flyAttributeChange.imageUrisToKeep,
    );

    //  Finally re-add attributes to firestore with newly added photo urls.
    newFlyService.addNewFlyAttributes(
      docId: flyAttributeChange.prevFly.docId,
      uid: authService.currentUser.uid,
      flyName: flyAttributeChange.updatedAttributes
          .firstWhere((attr) => attr.name == DbNames.flyName)
          .value,
      attributes: formAttributeData,
      topLevelImageUris: [
        ...flyAttributeChange.imageUrisToKeep,
        ...(await addedUris)
      ],
    );
  }

  Future _handleAddNewFlyInstruction(
      FlyInstructionChange instructionChange) async {
    // Add new files that user took with camera (or selected on device) to
    //  Firebase storage. Do not wait for future to resolve, so we can add
    //  or update doc in firestore to show user a preview quicker.
    Future<List<String>> addedUris = newFlyService.addFilesToStorage(
      uid: authService.currentUser.uid,
      images: instructionChange.imagesToAdd,
    );

    //  Now update the actual fly instructions doc, without any new photo urls
    //   added.
    newFlyService.addNewFlyInstruction(
      docId: instructionChange.fly.docId,
      uid: authService.currentUser.uid,
      title: instructionChange.title,
      description: instructionChange.description,
      stepNumber: instructionChange.step,
      imageUris: instructionChange.imageUrisToKeep,
    );
    //  Update the with the same instructions again, but we are awaiting for
    //  the call to storage to return with our urls.
    newFlyService.addNewFlyInstruction(
      docId: instructionChange.fly.docId,
      uid: authService.currentUser.uid,
      title: instructionChange.title,
      description: instructionChange.description,
      stepNumber: instructionChange.step,
      imageUris: [...(await addedUris), ...instructionChange.imageUrisToKeep],
    );
  }

  Future _handleDeleteFlyInProgress(Fly fly) async {
    newFlyService.deleteFlyInProgress(docId: fly.docId);
  }

  void close() {
    newFlyAttributesSink.close();
    newFlyMaterialSink.close();
    deleteFlyMaterialSink.close();
    newFlyInstructionSink.close();
    deleteFlyInstructionSink.close();
    deleteFlyInProgressSink.close();
  }
}
