import 'package:flutter/foundation.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/edit_new_fly_template_bloc.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/bloc/user_bloc.dart';

import 'completed_fly_bloc.dart';

class BlocProvider {
  final AuthBloc authBloc;
  final UserBloc userBloc;
  final EditNewFlyTemplateBloc editNewFlyTemplateBloc;
  final NewFlyBloc newFlyBloc;
  final CompletedFlyBloc completedFlyBloc;

  BlocProvider({
    @required this.authBloc,
    @required this.userBloc,
    @required this.editNewFlyTemplateBloc,
    @required this.newFlyBloc,
    @required this.completedFlyBloc,
  });
}
