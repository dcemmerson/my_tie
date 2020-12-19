import 'package:flutter/material.dart';
import 'package:my_tie/routes/routes.dart';

class SearchBar extends StatelessWidget {
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
                child: TextField(
                  onTap: () => Routes.flySearchPage(context),
                  onChanged: null,
                  // initialValue: 'abc',
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    isDense: true,
                    isCollapsed: true,
                    hintText: 'Search',
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      // ),
    );
  }
}
