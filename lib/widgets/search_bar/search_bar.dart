/// filename: search_bar.dart
/// description: SearchBar performs two functions:
///   1. On the tabbed appbar, allow user to tap on the search bar, which
///     routes the user to the search page
///   2. On the search page, allow the user to tap on the search bar and
///     begin searching for flies.
///   To distinguish the behavior of the search bar, just set the isSearchable
///   flage to false for option 1, or true for option 2.

import 'package:flutter/material.dart';
import 'package:my_tie/bloc/fly_search_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/routes/routes.dart';

class SearchBar extends StatelessWidget {
  final bool isSearchable;

  SearchBar({this.isSearchable});

  void _handleInput(String str, FlySearchBloc flySearchBloc) {
    flySearchBloc.flySearchTermSink.add(str);
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc =
        MyTieStateContainer.of(context).blocProvider.flySearchBloc;

    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.7),
          borderRadius: BorderRadius.all(Radius.circular(3))),

      child: Column(
        children: [
          Wrap(
            children: [
              Icon(Icons.search,
                  color: Theme.of(context).colorScheme.primaryVariant),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: GestureDetector(
                  onTap:
                      isSearchable ? null : () => Routes.flySearchPage(context),
                  child: TextField(
                    autofocus: true,
                    onChanged: (String s) => _handleInput(s, searchBloc),
                    enabled: isSearchable, //false,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      isDense: true,
                      isCollapsed: true,
                      hintText: 'Search',
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      // ),
    );
  }
}
