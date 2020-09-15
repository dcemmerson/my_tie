import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_in_progress_review_form_stream_builder.dart';

class NewFlyPreviewPublish extends StatelessWidget {
  Widget _buildPreview(NewFlyFormTransfer flyFormTransfer) {
    return Text('built');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FlyInProgressReviewFormStreamBuilder(
      child: _buildPreview,
    ));
  }
}
