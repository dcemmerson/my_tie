/// filename: fly_instruction_transfer.dart
/// last modified; 09/07/2020
/// description: Helper class used for transfering a fly instruction either
///   form bloc to widgets, or back from widgets to bloc. We maintain a reference
///   to both the entire fly, as well as an individual flyInstruction to explicitly
///   expose the flyInstruction that we intend to use, perform an operation on,
///   etc.

import '../fly.dart';
import '../fly_instruction.dart';

class FlyInstructionTransfer {
  final Fly fly;
  final FlyInstruction flyInstruction;

  FlyInstructionTransfer({this.fly, this.flyInstruction});

  Map getMergedInstructionsMapSortedAfterRemoval() {
    final List<FlyInstruction> mergedInstructions = fly.instructions
        .where((instr) => instr.step != flyInstruction.step)
        .toList()
          ..sort((a, b) => Fly.sortBySteps(a, b));

    return mergedInstructions.asMap().map((index, instr) {
      final int stepNumber = index + 1;
      final FlyInstruction copiedInstruction =
          FlyInstruction.copy(flyInstruction: instr, step: stepNumber);
      return MapEntry(stepNumber.toString(), copiedInstruction.toMap());
    });
  }
}
