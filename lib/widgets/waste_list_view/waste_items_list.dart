import 'package:flutter/material.dart';
import 'package:my_tie/bloc/auth_bloc.dart';
import 'package:my_tie/bloc/waste_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/widgets/waste_list_view/compact_list_tile.dart';
import 'package:my_tie/widgets/waste_list_view/empty_post.dart';
import 'package:my_tie/widgets/waste_list_view/expanded_list_tile.dart';

class WasteItems extends StatefulWidget {
  @override
  _WasteItemsState createState() => _WasteItemsState();
}

class _WasteItemsState extends State<WasteItems> {
  WasteBloc _wasteBloc;
  AuthBloc _authBloc;

  bool _isCompactListTileMode;
  bool _allUserEntries;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _wasteBloc = MyTieStateContainer.of(context).blocProvider.wasteBloc;
    _authBloc = MyTieStateContainer.of(context).blocProvider.authBloc;
    _allUserEntries = MyTieStateContainer.of(context).allUsersEntries;

    _isCompactListTileMode =
        MyTieStateContainer.of(context).isCompactWasteListMode;
  }

  Widget _buildList(String uid) {
    return Container(
        child: StreamBuilder(
      stream:
          _wasteBloc.getWastedItems(allUserEntries: _allUserEntries, uid: uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.data.length < 1) {
          return EmptyPostList();
        } else {
          if (_isCompactListTileMode) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => Semantics(
                    value: snapshot.data[index].name,
                    child: CompactListTile(wastedItem: snapshot.data[index])));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => Semantics(
                    value: snapshot.data[index].name,
                    child: ExpandedListTile(wastedItem: snapshot.data[index])));
          }
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authBloc.user.first,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Something unexpected occurred');
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              return _buildList(snapshot.data.uid);
            }
            return Text('Error loading data');
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
