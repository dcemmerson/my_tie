import 'package:flutter/foundation.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/waste_bloc.dart';

class BlocProvider {
  final AuthBloc authBloc;
  final WasteBloc wasteBloc;

  BlocProvider({@required this.wasteBloc, @required this.authBloc});
}
