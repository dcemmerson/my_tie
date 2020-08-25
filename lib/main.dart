import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_tie/app.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/bloc_provider.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/bloc/waste_bloc.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:my_tie/services/network/new_fly_service.dart';
import 'package:my_tie/services/network/waste_service.dart';

void main() async {
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
  final newFlyService = NewFlyService();
  final newFlyBloc =
      NewFlyBloc(newFlyService: newFlyService, authService: authService);
  final wasteService = WasteService();
  final wasteBloc = WasteBloc(wasteService);

  runApp(MyTieStateContainer(
      blocProvider: BlocProvider(
        authBloc: authBloc,
        newFlyBloc: newFlyBloc,
        wasteBloc: wasteBloc,
      ),
      child: WasteagramApp()));
}

Future<RemoteConfig> initRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  await remoteConfig.fetch(expiration: const Duration(hours: 5));
  await remoteConfig.activateFetched();
  return remoteConfig;
}
