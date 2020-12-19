/// filename: search_bar.dart
/// description: SearchBar performs two functions:
///   1. On the tabbed appbar, allow user to tap on the search bar, which
///     routes the user to the search page
///   2. On the search page, allow the user to tap on the search bar and
///     begin searching for flies.
///   To distinguish the behavior of the search bar, just set the isSearchable
///   flage to false for option 1, or true for option 2.

import 'package:flutter/material.dart';
import 'package:my_tie/routes/routes.dart';

class SearchBar extends StatelessWidget {
  final bool isSearchable;

  SearchBar({this.isSearchable});

  @override
  Widget build(BuildContext context) {
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
                    onChanged: null,
                    enabled: isSearchable, //false,
                    // initialValue: 'abc',
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
