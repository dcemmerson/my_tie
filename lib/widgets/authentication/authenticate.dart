import 'package:flutter/material.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/wasteagram_state.dart';
import 'package:my_tie/widgets/authentication/login_button_standalone.dart';

class Authenticate extends StatefulWidget {
  final Widget child;

  Authenticate({@required this.child});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  AuthBloc _authBloc;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = WasteagramStateContainer.of(context).blocProvider.authBloc;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _authBloc.user,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error occurred with firebase auth');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('waiting');
            // case ConnectionState.none:
            // // return Text('loading');
            // case ConnectionState.done:
            case ConnectionState.active:
              if (snapshot.data == null) {
                return LoginButtonStandalone();
              }
              return widget.child;
            default:
              return Text('default');
          }
        });
  }
}
