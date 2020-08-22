import 'package:flutter/material.dart';
import 'package:my_tie/bloc/wasteagram_state.dart';
import 'package:my_tie/pages/base/authenticate_base.dart';
import 'package:my_tie/widgets/authentication/login_button_standalone.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;

  RouteGuard({@required this.child});

  @override
  Widget build(BuildContext context) {
    var authBloc = WasteagramStateContainer.of(context).blocProvider.authBloc;

    return StreamBuilder(
      stream: authBloc.user,
      builder: (context, snapshot) {
        if (authBloc.currentUser == null) {
          return AuthenticateBase(child: LoginButtonStandalone());
        } else if (snapshot.hasError) {
          return Text('Error occurred with firebase auth');
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
          case ConnectionState.done:
          case ConnectionState.active:
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            }
            return child;
          default:
            return Text('default');
        }
      },
    );
  }
}
