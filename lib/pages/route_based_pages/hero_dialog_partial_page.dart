import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/fly_instruction_modal_transfer.dart';
import 'package:my_tie/widgets/forms/new_fly_form/preview_publish/instruction_preview/instruction_step_modal.dart';

class HeroDialogPartialPage extends StatelessWidget {
  static const route = 'hero_dialog_route';
  final FlyInstructionModalTransfer fimt;

  HeroDialogPartialPage({this.fimt});

  @override
  Widget build(BuildContext context) {
    return InstructionStepModal(fimt: fimt);
  }
}
