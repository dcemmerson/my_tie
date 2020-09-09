import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_tie/app.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/bloc_provider.dart';
import 'package:my_tie/bloc/edit_new_fly_template_bloc.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';
import 'package:my_tie/services/network/new_fly_service.dart';

void main() async {
  runApp(await initApp());
}

Future<Widget> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
  ]);

  final authService = AuthService(remoteConfig: await initRemoteConfig());
  final authBloc = AuthBloc(authService);

  final flyFormTemplateService = FlyFormTemplateService();
  final editNewFlyTemplateBloc = EditNewFlyTemplateBloc(
      authService: authService, flyFormTemplateService: flyFormTemplateService);

  final newFlyService = NewFlyService();

  final newFlyBloc = NewFlyBloc(
      newFlyService: newFlyService,
      authService: authService,
      flyFormTemplateService: flyFormTemplateService);

  return MyTieStateContainer(
    blocProvider: BlocProvider(
      authBloc: authBloc,
      newFlyBloc: newFlyBloc,
      editNewFlyTemplateBloc: editNewFlyTemplateBloc,
    ),
    child: MyTieApp(),
  );
}

Future<RemoteConfig> initRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  await remoteConfig.fetch(expiration: const Duration(hours: 5));
  await remoteConfig.activateFetched();
  return remoteConfig;
}
