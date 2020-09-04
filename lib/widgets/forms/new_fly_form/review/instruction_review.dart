/// filename: instruction_review.dart
/// last modified; 09/03/2020
/// description: Widget part of new fly form publish page. This widget is used
///   to display snippets of any fly instructions already in this user's fly
///   in progress doc in db.

import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/instruction_page_attribute.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/routes/fly_form_routes.dart';
import 'package:my_tie/styles/styles.dart';

class InstructionReview extends StatelessWidget {
  NewFlyFormTransfer nfft;

  InstructionReview({@required NewFlyFormTransfer newFlyFormTransfer})
      : nfft = newFlyFormTransfer;

  Widget _buildAddFirstStep(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(AppPadding.p4),
        child: GestureDetector(
            onTap: () => FlyFormRoutes.newFlyInstructionPage(
                context, InstructionPageAttribute(stepNumber: 1)),
            child: Row(
              children: [
                Icon(Icons.add),
                Text('Add the first step!',
                    style: TextStyle(fontSize: AppFonts.h6))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Column(
          children: [
            nfft.flyInProgress.instructions.length == 0
                ? _buildAddFirstStep(context)
                : Text('not implem.')
          ],
        ),
      ),
    );
  }
}
