import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/styles/styles.dart';

class NewFlyAttributePreview extends StatelessWidget {
  final Fly flyInProgress;

  NewFlyAttributePreview({this.flyInProgress});
  Widget _buildImageHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p2),
      child: Column(children: [
        Text(flyInProgress.flyName, style: AppTextStyles.header),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              FlyForm.difficulty.toTitleCase() + ':\t\t',
              style: AppTextStyles.subHeader,
            ),
            Text(
              flyInProgress.getAttribute(FlyForm.difficulty),
              style: AppTextStyles.subHeader,
            ),
            Icon(
              Icons.check_circle,
              size: AppIcons.small,
              color: AppIcons.getColorByDifficulty(
                flyInProgress.getAttribute(FlyForm.difficulty),
              ),
            )
          ],
        ),
      ]),
    );
  }

  Widget _buildImageFooter() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, AppPadding.p4, 0, AppPadding.p2),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                FlyForm.style.toTitleCase() +
                    ':  ' +
                    flyInProgress.getAttribute(FlyForm.style),
                style: AppTextStyles.subHeader),
            Text(
                FlyForm.type.toTitleCase() +
                    ':  ' +
                    flyInProgress.getAttribute(FlyForm.type),
                style: AppTextStyles.subHeader),
            Text(
                FlyForm.target.toTitleCase() +
                    ':  ' +
                    flyInProgress.getAttribute(FlyForm.target),
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

  Widget _buildCarousel() {
    return CarouselSlider(
      items: flyInProgress.topLevelImageUris
          .map((uri) => _toImageWithLoadingBar(uri))
          .toList(),
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: flyInProgress.topLevelImageUris.length > 1,
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildImageHeader(),
      _buildCarousel(),
      _buildImageFooter(),
    ]);
  }
}
