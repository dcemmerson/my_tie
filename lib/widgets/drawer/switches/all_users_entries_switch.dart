import 'package:flutter/material.dart';
import 'package:my_tie/bloc/wasteagram_state.dart';
import 'package:my_tie/styles/styles.dart';

class AllUsersEntriesSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WasteagramState wasteagramState = WasteagramStateContainer.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('All users ', style: TextStyle(fontSize: AppFonts.h3)),
      Semantics(
        button: true,
        label: 'All users',
        hint: 'See all user\'s entries',
        toggled: wasteagramState.allUsersEntries,
        child: Switch(
            value: wasteagramState.allUsersEntries,
            onChanged: (value) => wasteagramState.toggleAllUsersEntries()),
      )
    ]);
  }
}
