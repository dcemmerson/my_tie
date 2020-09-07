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

import '../db_names.dart';
import '../fly.dart';
import '../fly_instruction.dart';

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
        imagesToAdd = _extractImagesToAdd(prevInstruction, updatedInstruction),
        imageUrisToKeep =
            _extractImageUrisToKeep(prevInstruction, updatedInstruction);

  static List<File> _extractImagesToAdd(
      FlyInstruction prevInstruction, Map updatedInstruction) {
    final List<File> imageFilesToAdd =
        updatedInstruction[DbNames.instructionImages]
            .whereType<File>()
            .toList();

    return imageFilesToAdd;
  }

  static List<String> _extractImageUrisToKeep(
      FlyInstruction prevInstruction, Map updatedInstruction) {
    //final List<String>
    print(prevInstruction);
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
