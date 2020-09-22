/// filename: user_bloc.dart
/// description: BLoC related to user collection and profile pages.
///   This class is responsible for
///   communicating between UserService class (which communicates with
///   Firestore) and our app, and perform and business logic necessary.

import 'dart:async';

import 'package:my_tie/bloc/stream_transformers/document_to_user_profile.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:my_tie/services/network/user_service.dart';

class UserBloc {
  final UserService userService;
  final AuthService authService;

  //Inputs - coming from app.

  //Outputs - either going to wasteagram or uses services to Firebase.
  // Stream<UserProfile> get userProfile => _authStatusController.stream;
  // StreamController<UserProfile> _authStatusController =
  //     BehaviorSubject<UserProfile>(seedValue: null);

  UserBloc({this.userService, this.authService}) {
    // userService
    //     .getUserProfile(authService.currentUser.uid)
    //     .listen((user) => _authStatusController.add(user));
  }

  Stream<UserProfile> get userProfile {
    print(authService.currentUser.uid);
    return userService
        .getUserProfile(authService.currentUser.uid)
        .transform(DocumentToUserProfile());
  }

  close() {
    // _authStatusController.close();
  }
}
