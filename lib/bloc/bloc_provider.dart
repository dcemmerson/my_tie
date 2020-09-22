import 'package:flutter/foundation.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/edit_new_fly_template_bloc.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/bloc/user_bloc.dart';

class BlocProvider {
  final AuthBloc authBloc;
  final EditNewFlyTemplateBloc editNewFlyTemplateBloc;
  final NewFlyBloc newFlyBloc;
  final UserBloc userBloc;

  BlocProvider({
    @required this.authBloc,
    @required this.editNewFlyTemplateBloc,
    @required this.newFlyBloc,
    @required this.userBloc,
  });
}
