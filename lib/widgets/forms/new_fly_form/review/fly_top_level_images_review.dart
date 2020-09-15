import 'package:flutter/material.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_top_level_photos/fly_top_level_photo_input.dart';

class FlyTopLevelImagesReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Column(children: [FlyTopLevelPhotoInput()]),
    );
  }
}
