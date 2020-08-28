import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/styles/styles.dart';

class ThemeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyTieState wasteagramState = MyTieStateContainer.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Dark Mode ', style: TextStyle(fontSize: AppFonts.h3)),
      Semantics(
        button: true,
        label: 'Dark mode',
        hint: 'Toggle dark mode',
        toggled: wasteagramState.isDarkMode,
        child: Switch(
            value: wasteagramState.isDarkMode,
            onChanged: (value) => wasteagramState.toggleDarkMode()),
      )
    ]);
  }
}
