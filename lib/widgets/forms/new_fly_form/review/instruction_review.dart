/// filename: instruction_review.dart
/// last modified; 09/03/2020
/// description: Widget part of new fly form publish page. This widget is used
///   to display snippets of any fly instructions already in this user's fly
///   in progress doc in db.

import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/instruction_page_attribute.dart';
import 'package:my_tie/models/fly_instruction.dart';
import 'package:my_tie/models/keys.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/routes/fly_form_routes.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/review/review_edit_button.dart';

class InstructionReview extends StatelessWidget {
  static const _addFirstStep = 'Add the first step!';
  static const _addNextStep = 'Add next step!';

  final NewFlyFormTransfer nfft;

  InstructionReview({@required NewFlyFormTransfer newFlyFormTransfer})
      : nfft = newFlyFormTransfer;

  Widget _buildNextStep(BuildContext context, {int nextStepNumber: 1}) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppPadding.p4),
              child: GestureDetector(
                onTap: () => FlyFormRoutes.newFlyInstructionPage(context,
                    InstructionPageAttribute(stepNumber: nextStepNumber)),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      key: ValueKey(Keys.addInstructionKey),
                    ),
                    Text(nextStepNumber == 1 ? _addFirstStep : _addNextStep,
                        style: TextStyle(fontSize: AppFonts.h6))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _instructionPreview(BuildContext context, FlyInstruction instruction) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Column(children: [
          Row(
            key: ValueKey('Step ${instruction.step}'),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Step ${instruction.step}', style: AppTextStyles.header),
              ReviewEditButton(
                semanticLabel: 'Edit instruction step',
                onPressedCallback: () => FlyFormRoutes.newFlyInstructionPage(
                    context,
                    InstructionPageAttribute(stepNumber: instruction.step)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                AppPadding.p2, 0, AppPadding.p2, AppPadding.p1),
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Text(instruction.title,
                    style: TextStyle(
                        fontSize: AppFonts.h5, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                AppPadding.p2, 0, AppPadding.p2, AppPadding.p1),
            alignment: Alignment.bottomLeft,
            child: Row(children: [
              Flexible(
                child: Text(
                  instruction.description,
                  style: TextStyle(fontSize: AppFonts.h6),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  List<Widget> _buildInstructionsPreview(
      BuildContext context, List<FlyInstruction> flyInstructions) {
    return flyInstructions.map((FlyInstruction instruction) {
      return _instructionPreview(context, instruction);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._buildInstructionsPreview(context, nfft.flyInProgress.instructions),
      _buildNextStep(context,
          nextStepNumber: nfft.flyInProgress.instructions.length + 1)
    ]);
  }
}
