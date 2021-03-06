/// filename: fly_instruction_change.dart
/// last modified: 09/04/2020
/// description: Class used for transferring an instruction step (whether user
///   is updating a step or adding a new step) from add instruction step page
///   to new_fly_bloc. This class performs the task of looking at the inputs
///   from the ui, comparing those with the instruction being editted (if it is
///   being editted), and determining which uris need to be deleted and which
///   uris to keep. The actual task of adding and deleting uris from storage
///   is done in new_fly_bloc.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/fly_instruction.dart';

import '../db_names.dart';

class FlyInstructionChange {
  final Fly fly;

  final String title;
  final String description;
  final int step;

  final List<File> imagesToAdd;
  final List<String> imageUrisToKeep;

  FlyInstructionChange(
      {this.fly, FlyInstruction prevInstruction, Map updatedInstruction})
      : title = updatedInstruction[DbNames.instructionTitle],
        description = updatedInstruction[DbNames.instructionDescription],
        step = updatedInstruction[DbNames.instructionStep],
        imagesToAdd = _extractImagesToAdd(updatedInstruction),
        imageUrisToKeep = _extractImageUrisToKeep(updatedInstruction);

  static List<File> _extractImagesToAdd(Map updatedInstruction) {
    final List<File> imageFilesToAdd =
        updatedInstruction[DbNames.instructionImages]
            .whereType<File>()
            .toList();

    return imageFilesToAdd;
  }

  static List<String> _extractImageUrisToKeep(Map updatedInstruction) {
    List<String> imageUrisFromPrevInstruction = _toListOfString(
      updatedInstruction[DbNames.instructionImages]
          .where((img) => (img is Image && img.image is NetworkImage))
          .map((img) => img.image.url)
          .toList(),
    );

    return imageUrisFromPrevInstruction;
  }

  static List<String> _toListOfString(List imgUris) =>
      imgUris?.map((imgUri) => imgUri.toString())?.toList();
}
