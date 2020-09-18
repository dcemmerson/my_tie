import 'package:flutter/material.dart';
import 'package:my_tie/widgets/forms/new_fly_form/preview_publish/instruction_preview/instruction_step_modal.dart';

class InstructionModalPage extends StatelessWidget {
  static const title = 'Instruction Preview';
  static const route = '/new_fly/preview_instruction_detail';

  @override
  Widget build(BuildContext context) {
    return InstructionStepModal();
  }
}
