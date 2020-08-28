import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_container.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;

  RouteGuard({@required this.child});

  @override
  Widget build(BuildContext context) {
    var authBloc = MyTieStateContainer.of(context).blocProvider.authBloc;

    return StreamBuilder(
      stream: authBloc.user,
      builder: (context, snapshot) {
        if (authBloc.currentUser == null) {
          return PageContainer(
            pageType: PageType.AuthenticationPage,
          );
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
