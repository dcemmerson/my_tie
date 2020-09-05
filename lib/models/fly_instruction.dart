import 'dart:io';

import 'db_names.dart';
import 'package:my_tie/styles/string_format.dart';

class FlyInstruction {
  final String title;
  final String description;
  final int step;

  final List<String> imageUris;
  final List<File> images;

  FlyInstruction(
      {this.title, this.description, this.step, this.imageUris, List images})
      : this.images = _toListOfFile(images);

  FlyInstruction.formattedForReview(Map doc)
      : step = doc[DbNames.instructionStep],
        description =
            doc[DbNames.instructionDescription].toString().toPreview(),
        title = doc[DbNames.instructionTitle].toString().toPreview(),
        imageUris = _toListOfString(doc[DbNames.instructionImageUris]),
        images = _toListOfFile(doc[DbNames.instructionImages]);

  FlyInstruction.fromDoc(Map doc)
      : step = doc[DbNames.instructionStep],
        description = doc[DbNames.instructionDescription],
        title = doc[DbNames.instructionTitle].toString(),
        imageUris = _toListOfString(doc[DbNames.instructionImageUris]),
        images = _toListOfFile(doc[DbNames.instructionImages]);

  Map toMap() => {
        'title': title,
        'description': description,
        'step': step,
        'images': images
      };

  static List<String> _toListOfString(List imgUris) =>
      imgUris?.map((imgUri) => imgUri.toString())?.toList();

  static List<File> _toListOfFile(List imgs) =>
      imgs?.map((dynImg) => dynImg as File)?.toList();
}
