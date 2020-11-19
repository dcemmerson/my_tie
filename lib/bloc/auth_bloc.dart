/// filename: auth_bloc.dart
/// description: BLoC related to authentication. This class is responsible for
///   communicating between AuthService class (which communicates with
///   Firestore) and our app. Class used to authenticate user using variety of
///   auth patterns (gmail, github, etc), as well as providing access throughout
///   app (via inherited widget setup in MyTieStateContainer).

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:rxdart/rxdart.dart';

enum LoginType { Gmail, Github, Facebook, Twitter, Apple }

class AuthBloc {
  final AuthService _authService;
  LoginType loginType;

  static getLoginTypeString(LoginType loginType) {
    switch (loginType) {
      case LoginType.Facebook:
        return 'facebook';
      case LoginType.Github:
        return 'github';
      case LoginType.Gmail:
        return 'gmail';
      case LoginType.Twitter:
        return 'twitter';
      case LoginType.Apple:
        return 'apple';
      default:
        return 'gmail';
    }
  }

  static LoginType getLoginType(String str) {
    switch (str) {
      case 'facebook':
        return LoginType.Facebook;
      case 'github':
        return LoginType.Github;
      case 'gmail':
        return LoginType.Gmail;
      case 'twitter':
        return LoginType.Twitter;
      case 'apple':
        return LoginType.Apple;
      default:
        return LoginType.Gmail;
    }
  }

  Stream<User> get user => _authStatusController.stream;
  StreamController<User> _authStatusController =
      BehaviorSubject<User>(seedValue: null);

  AuthBloc(this._authService) {
    _authService.authStatus.listen((user) {
      _authStatusController.add(user);
    });
  }

  Future<UserCredential> signIn({LoginType type, BuildContext context}) {
    loginType = type;
    switch (loginType) {
      case LoginType.Github:
        return _authService.signInWithGitHub(context);
      case LoginType.Facebook:
      case LoginType.Gmail:
      default:
        return _authService.signInWithGoogle();
    }
  }

  User get currentUser => _authService.currentUser;

  Future logout() {
    switch (loginType) {
      case LoginType.Github:
        return _authService.logoutGithub();
      case LoginType.Facebook:
      case LoginType.Gmail:
        return _authService.logoutGoogle();
      default:
        return _authService.logoutGithub();
    }
  }

  close() {
    _authStatusController.close();
  }
}

class LoginCredentials {
  String email;
  String password;
}
