import 'package:flutter/foundation.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/edit_new_fly_template_bloc.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/favorited_fly_exhibit_bloc.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/bloc/user_bloc.dart';

import 'fly_exhibit_bloc/newest_fly_exhibit_bloc.dart';

class BlocProvider {
  final AuthBloc authBloc;
  final UserBloc userBloc;
  final EditNewFlyTemplateBloc editNewFlyTemplateBloc;
  final NewFlyBloc newFlyBloc;
  final NewestFlyExhibitBloc newestFlyExhibitBloc;
  final FavoritedFlyExhibitBloc favoritedFlyExhibitBloc;

  BlocProvider({
    @required this.authBloc,
    @required this.userBloc,
    @required this.editNewFlyTemplateBloc,
    @required this.newFlyBloc,
    @required this.newestFlyExhibitBloc,
    @required this.favoritedFlyExhibitBloc,
  });
}
