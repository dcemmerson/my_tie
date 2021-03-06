import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_tie/app.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/bloc_provider.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/favoriting_bloc.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/newest_fly_exhibit_bloc.dart';
import 'package:my_tie/bloc/edit_new_fly_template_bloc.dart';
import 'package:my_tie/bloc/fly_search_bloc.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';
import 'package:my_tie/services/network/new_fly_service.dart';
import 'package:my_tie/services/network/user_service.dart';

import 'bloc/fly_exhibit_bloc/by_materials_fly_exhibit_bloc.dart';
import 'bloc/fly_exhibit_bloc/favorited_fly_exhibit_bloc.dart';
import 'bloc/user_bloc.dart';
import 'services/network/fly_exhibit_services/by_materials_fly_exhibit_service.dart';
import 'services/network/fly_exhibit_services/favorited_fly_exhibit_service.dart';
import 'services/network/fly_exhibit_services/newest_fly_exhibit_service.dart';

// import 'package:flutter/scheduler.dart' show timeDilation;

void main() async {
  runApp(await initApp());
}

Future<Widget> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseFirestore.instance.settings = Settings(
  //     host: '10.0.2.2:8080', sslEnabled: false, persistenceEnabled: false);
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

  final userService = UserService();
  final userBloc = UserBloc(
      userService: userService,
      authService: authService,
      flyFormTemplateService: flyFormTemplateService);

  final newFlyService = NewFlyService();

  final newFlyBloc = NewFlyBloc(
      newFlyService: newFlyService,
      authService: authService,
      flyFormTemplateService: flyFormTemplateService);

  final flySearchBloc = FlySearchBloc(
      userBloc: userBloc, flyFormTemplateService: flyFormTemplateService);

  final newestFlyExhibitService = NewestFlyExhibitService();
  final newestFlyExhibitBloc = NewestFlyExhibitBloc(
    userBloc: userBloc,
    newestFlyExhibitService: newestFlyExhibitService,
    flyFormTemplateService: flyFormTemplateService,
    flySearchBloc: flySearchBloc,
  );

  final favoritedFlyExhibitService = FavoritedFlyExhibitService();
  final favoritedFlyExhibitBloc = FavoritedFlyExhibitBloc(
    userBloc: userBloc,
    favoritedFlyExhibitService: favoritedFlyExhibitService,
    flyFormTemplateService: flyFormTemplateService,
    flySearchBloc: flySearchBloc,
  );

  final byMaterialsFlyExhibitService = ByMaterialsFlyExhibitService();
  final byMaterialsFlyExhibitBloc = ByMaterialsFlyExhibitBloc(
    userBloc: userBloc,
    byMaterialsFlyExhibitService: byMaterialsFlyExhibitService,
    flyFormTemplateService: flyFormTemplateService,
    flySearchBloc: flySearchBloc,
  );

  FavoritingBloc.sharedInstance
      .init(flyExhibitService: favoritedFlyExhibitService, userBloc: userBloc);

  return MyTieStateContainer(
    blocProvider: BlocProvider(
      authBloc: authBloc,
      userBloc: userBloc,
      editNewFlyTemplateBloc: editNewFlyTemplateBloc,
      newFlyBloc: newFlyBloc,
      newestFlyExhibitBloc: newestFlyExhibitBloc,
      favoritedFlyExhibitBloc: favoritedFlyExhibitBloc,
      byMaterialsFlyExhibitBloc: byMaterialsFlyExhibitBloc,
      flySearchBloc: flySearchBloc,
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
