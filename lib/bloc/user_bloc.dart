/// filename: user_bloc.dart
/// description: BLoC related to user collection and profile pages.
///   This class is responsible for
///   communicating between UserService class (which communicates with
///   Firestore) and our app, and perform and business logic necessary.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/bloc_transfer_related/user_profile_fly_material_add_or_delete.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';
import 'package:my_tie/services/network/user_service.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final UserService userService;
  final AuthService authService;
  final FlyFormTemplateService flyFormTemplateService;

  //Inputs - coming from app.
  // Coming from app.
  StreamController<UserProfileFlyMaterialAddOrDelete> addUserFlyMaterialSink =
      StreamController<UserProfileFlyMaterialAddOrDelete>();
  StreamController<UserProfileFlyMaterialAddOrDelete>
      deleteUserFlyMaterialSink =
      StreamController<UserProfileFlyMaterialAddOrDelete>();

  //Outputs - either going to wasteagram or uses services to Firebase.
  // Stream<UserProfile> get userProfile => _authStatusController.stream;
  // StreamController<UserProfile> _authStatusController =
  //     BehaviorSubject<UserProfile>(seedValue: null);

  UserBloc({this.userService, this.authService, this.flyFormTemplateService}) {
    addUserFlyMaterialSink.stream.listen(_handleAddUserFlyMaterial);
    deleteUserFlyMaterialSink.stream.listen(_handleDeleteUserFlyMaterial);
    // userService
    //     .getUserProfile(authService.currentUser.uid)
    //     .listen((user) => _authStatusController.add(user));
  }

  void _handleDeleteUserFlyMaterial(UserProfileFlyMaterialAddOrDelete upfmd) {
    userService.deleteUserProfileMaterial(
        uid: authService.currentUser.uid,
        docId: upfmd.userProfile.docId,
        name: upfmd.flyMaterial.name,
        properties: upfmd.flyMaterial.properties);
  }

  void _handleAddUserFlyMaterial(UserProfileFlyMaterialAddOrDelete upfma) {
    userService.addUserProfileMaterial(
        uid: authService.currentUser.uid,
        docId: upfma.userProfile.docId,
        name: upfma.flyMaterial.name,
        properties: upfma.flyMaterial.properties);
  }

  Stream<UserMaterialsTransfer> get userMaterialsProfile {
    Stream<QuerySnapshot> userProfileStream =
        userService.getUserProfileStream(authService.currentUser.uid);
    Stream<QuerySnapshot> flyTemplateDocStream =
        flyFormTemplateService.newFlyFormStream;

    return CombineLatestStream.combine2(
      userProfileStream,
      flyTemplateDocStream,
      (QuerySnapshot userProfileDoc, QuerySnapshot nfftDocs) {
        final newFlyFormTemplate =
            NewFlyFormTemplate.fromDoc(nfftDocs?.docs[0]?.data());
        final userProfile = UserProfile.fromDoc(userProfileDoc?.docs[0]?.data(),
            docId: userProfileDoc?.docs[0]?.id);

        return UserMaterialsTransfer(
          userProfile: userProfile,
          flyFormMaterials: newFlyFormTemplate.flyFormMaterials,
        );
      },
    );
  }

  void addToFavorites(String uDocId, String docId) {
    userService.addFavorite(uDocId, docId);
  }

  void removeFromFavorites(String uDocId, String docId) {
    userService.removeFavorite(uDocId, docId);
  }

  close() {
    addUserFlyMaterialSink.close();
    deleteUserFlyMaterialSink.close();
  }
}
