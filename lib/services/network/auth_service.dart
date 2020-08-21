import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  RemoteConfig remoteConfig;

  AuthService({this.remoteConfig}) {
    //   _initRemoteConfig();
  }

  void _initRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
  }

  Stream<User> get authStatus => FirebaseAuth.instance.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<UserCredential> signInWithGitHub(BuildContext context) async {
    try {
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: remoteConfig.getString('github_client_id'),
        clientSecret: remoteConfig.getString('github_client_secret'),
        redirectUrl: remoteConfig.getString('github_callback_url'),
      );

      // Trigger the sign-in flow
      final result = await gitHubSignIn.signIn(context);

      // Create a credential from the access token
      final AuthCredential githubAuthCredential =
          GithubAuthProvider.credential(result.token);

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance
          .signInWithCredential(githubAuthCredential);
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future logoutGoogle() async {
    await GoogleSignIn().disconnect();
    return await _logoutFirebase();
  }

  Future logoutGithub() async {
    return await _logoutFirebase();
  }

  Future _logoutFirebase() async {
    return await FirebaseAuth.instance.signOut();
  }
}
