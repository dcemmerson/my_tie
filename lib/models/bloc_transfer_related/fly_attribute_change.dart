/// filename: fly_attribute_change.dart
/// last modified: 09/15/2020
/// description: Class used for transferring an attribute from add attribute page
///   to new_fly_bloc. This class performs the task of looking at the inputs
///   from the ui, comparing those with the previous (if any) attributes for
///   this fly, and determining which uris need to be deleted and which
///   uris to keep. The actual task of adding and deleting uris from storage
///   is done in new_fly_bloc.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly.dart';

import '../db_names.dart';
import '../new_fly/fly_attribute.dart';

class FlyAttributeChange {
  final Fly prevFly;

  final List<FlyAttribute> updatedAttributes;

  final List<File> imagesToAdd;
  final List<String> imageUrisToKeep;

  FlyAttributeChange({this.prevFly, Map attributes})
      : imagesToAdd = _extractImagesToAdd(attributes),
        imageUrisToKeep = _extractImageUrisToKeep(attributes),
        updatedAttributes = _extractAttributes(attributes);

  static List<FlyAttribute> _extractAttributes(Map attributesForm) {
    // First get rid of the image part of attributesForm Map.
    attributesForm.removeWhere((key, value) => value is List);

    final flyAttributes = List<FlyAttribute>();
    attributesForm.forEach((key, value) {
      flyAttributes.add(FlyAttribute(name: key, value: value));
    });

    return flyAttributes;
  }

  static List<File> _extractImagesToAdd(Map attributesForm) {
    return attributesForm[DbNames.topLevelImageUris].whereType<File>().toList();
  }

  static List<String> _extractImageUrisToKeep(Map attributesForm) {
    List<String> imageUrisFromPrevInstruction = _toListOfString(
      attributesForm[DbNames.topLevelImageUris]
          .where((img) => (img is Image && img.image is NetworkImage))
          .map((img) => img.image.url)
          .toList(),
    );

    return imageUrisFromPrevInstruction;
  }

  // List<FlyAttribute> _extractAttributes(Map form) {
  //   final attributes = List<FlyAttribute>();
  //   form.forEach((key, value) {
  //     if(value is File)
  //   });
  //   return attributes;
  // }

  // static List<File> _extractImagesToAdd(
  //     FlyInstruction prevInstruction, Map updatedInstruction) {
  //   final List<File> imageFilesToAdd =
  //       updatedInstruction[DbNames.instructionImages]
  //           .whereType<File>()
  //           .toList();

  //   return imageFilesToAdd;
  // }

  // static List<String> _extractImageUrisToKeep(
  //     FlyInstruction prevInstruction, Map updatedInstruction) {
  //   List<String> imageUrisFromPrevInstruction = _toListOfString(
  //     updatedInstruction[DbNames.instructionImages]
  //         .where((img) => (img is Image && img.image is NetworkImage))
  //         .map((img) => img.image.url)
  //         .toList(),
  //   );

  //   return imageUrisFromPrevInstruction;
  // }

  static List<String> _toListOfString(List imgUris) =>
      imgUris?.map((imgUri) => imgUri.toString())?.toList();
}
