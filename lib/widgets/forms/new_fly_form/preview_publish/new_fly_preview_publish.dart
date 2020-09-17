import 'package:flutter/material.dart';

import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_in_progress_review_form_stream_builder.dart';
import 'package:my_tie/widgets/forms/new_fly_form/preview_publish/new_fly_attribute_preview.dart';

import 'new_fly_instructions_preview.dart';
import 'new_fly_material_preview.dart';

class NewFlyPreviewPublish extends StatelessWidget {
  Widget _buildPreview(
      NewFlyFormTransfer flyFormTransfer, BuildContext context) {
    return Column(children: [
      NewFlyAttributePreview(flyInProgress: flyFormTransfer.flyInProgress),
      NewFlyMaterialPreview(
          materialList: flyFormTransfer.flyInProgress.materialList),
      NewFlyInstructionsPreview(
          instructions: flyFormTransfer.flyInProgress.instructions)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FlyInProgressReviewFormStreamBuilder(
      child: (NewFlyFormTransfer nfft) => _buildPreview(nfft, context),
    ));
  }
}
