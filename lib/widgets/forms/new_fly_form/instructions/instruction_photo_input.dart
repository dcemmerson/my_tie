import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InstructionPhotoInput extends StatelessWidget {
  final String title;
  final String label;
  final String attribute;
  final List<String> imageUris;

  InstructionPhotoInput(
      {this.title, this.label, this.attribute, this.imageUris});

  @override
  Widget build(BuildContext context) {
    return FormBuilderImagePicker(
      attribute: attribute,
      initialValue: imageUris
          ?.map((uri) => Image.network(
                uri,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return LinearProgressIndicator(
                      value: loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes,
                    );
                  }
                  return child;
                },
              ))
          ?.toList(),
      decoration: InputDecoration(labelText: label),
      validators: [
        FormBuilderValidators.required(),
      ],
    );
  }
}
