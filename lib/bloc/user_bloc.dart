/// filename: user_bloc.dart
/// description: BLoC related to user collection and profile pages.
///   This class is responsible for
///   communicating between UserService class (which communicates with
///   Firestore) and our app, and perform and business logic necessary.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/bloc/stream_transformers/document_to_user_profile.dart';
import 'package:my_tie/models/db_names.dart';
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

  //Outputs - either going to wasteagram or uses services to Firebase.
  // Stream<UserProfile> get userProfile => _authStatusController.stream;
  // StreamController<UserProfile> _authStatusController =
  //     BehaviorSubject<UserProfile>(seedValue: null);

  UserBloc({this.userService, this.authService, this.flyFormTemplateService}) {
    // userService
    //     .getUserProfile(authService.currentUser.uid)
    //     .listen((user) => _authStatusController.add(user));
  }

  // Stream<UserProfile> get userProfile {
  //   print(authService.currentUser.uid);
  //   return userService
  //       .getUserProfile(authService.currentUser.uid)
  //       .transform(DocumentToUserProfile());
  // }

  Stream<UserMaterialsTransfer> get userMaterialsProfile {
    Stream<QuerySnapshot> userProfileStream =
        userService.getUserProfile(authService.currentUser.uid);
    Stream<QuerySnapshot> flyTemplateDocStream =
        flyFormTemplateService.newFlyFormStream;

    return CombineLatestStream.combine2(
      userProfileStream,
      flyTemplateDocStream,
      (QuerySnapshot userProfileDoc, QuerySnapshot nfftDocs) {
        final newFlyFormTemplate =
            NewFlyFormTemplate.fromDoc(nfftDocs?.docs[0]?.data());
        final userProfile =
            UserProfile.fromDoc(userProfileDoc?.docs[0]?.data());

        return UserMaterialsTransfer(
          userProfile: userProfile,
          flyFormMaterials: newFlyFormTemplate.flyFormMaterials,
        );
      },
    );
  }

  close() {
    // _authStatusController.close();
  }
}
