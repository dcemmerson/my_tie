import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/styles/styles.dart';

class CompactWasteListSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyTieState wasteagramState = MyTieStateContainer.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Compact ', style: TextStyle(fontSize: AppFonts.h3)),
      Semantics(
        button: true,
        label: 'Compact mode',
        hint: 'Toggle compact mode',
        toggled: wasteagramState.isCompactWasteListMode,
        child: Switch(
            value: wasteagramState.isCompactWasteListMode,
            onChanged: (value) => wasteagramState.toggleCompactWasteListMode()),
      )
    ]);
  }
}
