import 'package:flutter/foundation.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/edit_new_fly_template_bloc.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';

class BlocProvider {
  final AuthBloc authBloc;
  final NewFlyBloc newFlyBloc;
  final EditNewFlyTemplateBloc editNewFlyTemplateBloc;

  BlocProvider({
    @required this.authBloc,
    @required this.newFlyBloc,
    @required this.editNewFlyTemplateBloc,
  });
}
