import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/styles/styles.dart';

class CompactFlyListSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyTieState myTieState = MyTieStateContainer.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Compact ', style: TextStyle(fontSize: AppFonts.h3)),
      Semantics(
        button: true,
        label: 'Compact mode',
        hint: 'Toggle compact mode',
        toggled: myTieState.isCompactFlyListMode,
        child: Switch(
            value: myTieState.isCompactFlyListMode,
            onChanged: (value) => myTieState.toggleCompactFlyListMode()),
      )
    ]);
  }
}
