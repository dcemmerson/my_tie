import 'package:flutter/material.dart';
import 'package:my_tie/models/fly_instruction.dart';
import 'package:my_tie/styles/styles.dart';

class NewFlyInstructionsPreview extends StatelessWidget {
  final List<FlyInstruction> instructions;

  NewFlyInstructionsPreview({this.instructions});

  Widget _buildInstructionsHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(
            AppPadding.p2, AppPadding.p6, AppPadding.p2, AppPadding.p2),
        child: Opacity(
            opacity: 0.9,
            child: Text('Instructions',
                style: TextStyle(
                  fontSize: AppFonts.h3,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: TextDecoration.underline,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildInstructionsHeader(context)],
    );
  }
}
