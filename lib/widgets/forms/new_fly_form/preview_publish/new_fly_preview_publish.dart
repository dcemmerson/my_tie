import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_in_progress_review_form_stream_builder.dart';

class NewFlyPreviewPublish extends StatelessWidget {
  Widget _buildImageHeader(Fly fly) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p2),
      child: Column(children: [
        Text(fly.flyName, style: AppTextStyles.header),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              FlyForm.difficulty.toTitleCase() + ':\t\t',
              style: AppTextStyles.subHeader,
            ),
            Text(
              fly.getAttribute(FlyForm.difficulty),
              style: AppTextStyles.subHeader,
            ),
            Icon(
              Icons.check_circle,
              size: AppIcons.small,
              color: AppIcons.getColorByDifficulty(
                fly.getAttribute(FlyForm.difficulty),
              ),
            )
          ],
        ),
      ]),
    );
  }

  Widget _buildImageFooter(Fly fly) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p2),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                FlyForm.style.toTitleCase() +
                    ':  ' +
                    fly.getAttribute(FlyForm.style),
                style: AppTextStyles.subHeader),
            Text(
                FlyForm.type.toTitleCase() +
                    ':  ' +
                    fly.getAttribute(FlyForm.type),
                style: AppTextStyles.subHeader),
            Text(
                FlyForm.target.toTitleCase() +
                    ':  ' +
                    fly.getAttribute(FlyForm.target),
                style: AppTextStyles.subHeader)
          ],
        )
      ]),
    );
  }

  Widget _toImageWithLoadingBar(String uri) {
    return Image.network(
      uri,
      fit: BoxFit.cover,
      width: 1000,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) {
          return Center(
            child: LinearProgressIndicator(
              value: loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes,
            ),
          );
        }
        return child;
      },
    );
  }

  Widget _buildCarousel(Fly flyInProgress) {
    return CarouselSlider(
      items: flyInProgress.topLevelImageUris
          .map((uri) => _toImageWithLoadingBar(uri))
          .toList(),
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        // onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildPreview(NewFlyFormTransfer flyFormTransfer) {
    return Column(children: [
      _buildImageHeader(flyFormTransfer.flyInProgress),
      _buildCarousel(flyFormTransfer.flyInProgress),
      _buildImageFooter(flyFormTransfer.flyInProgress),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FlyInProgressReviewFormStreamBuilder(
      child: _buildPreview,
    ));
  }
}
// ...flyFormTransfer.flyInProgress.materials
//     .where((flyMaterials) =>
//         flyMaterials.flyMaterials != null &&
//         flyMaterials.flyMaterials.length > 0)
//     .map((mat) => Text(mat.name))
//     .toList(),
