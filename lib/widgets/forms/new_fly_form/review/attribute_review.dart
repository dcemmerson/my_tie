/// filename: attribute_review.dart
/// description: Build Card widget with fly in progress attributes to paint
///   on screen for user. We take the NewFlyFormTransfer object, which contains
///   the fly in progress and the fly form template. Find the attribute fields
///   in fly form template (eg ['difficulty', 'type', 'style', etc]), then
///   search the fly in progress for these matching attribute values and place
///   in Text widgets.

import 'package:flutter/material.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_form_attribute.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/routes/fly_form_routes.dart';
import 'package:my_tie/styles/styles.dart';

class AttributeReview extends StatelessWidget {
  final _iconButtonPadding = 8.0;
  final _semanticLabel = 'Tap to edit';
  final NewFlyFormTransfer nfft;
  final int pageNumber;

  AttributeReview(
      {@required NewFlyFormTransfer newFlyFormTransfer, this.pageNumber = 1})
      : nfft = newFlyFormTransfer;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: Theme.of(context).iconTheme.size + 4 * _iconButtonPadding,
              height: Theme.of(context).iconTheme.size + 2 * _iconButtonPadding,
            ),
            Text(nfft.flyInProgress.flyName, style: AppTextStyles.header),
            IconButton(
              onPressed: () => FlyFormRoutes.newFlyAttributesPage(context),

              // NewFlyFormPublish.popToPage(
              //     ctx: context,
              //     pageCount:
              //         nfft.newFlyFormTemplate.flyFormMaterials.length + 1,
              //     popToPage: pageNumber - 1),
              icon: Icon(
                Icons.edit,
                semanticLabel: _semanticLabel,
              ),
            )
          ]),
          ...nfft.newFlyFormTemplate.flyFormAttributes
              .map(
                (FlyFormAttribute attr) => Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(attr.name,
                                  style: AppTextStyles.subHeader))),
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                  nfft.flyInProgress.getAttribute(attr.name) ??
                                      'None',
                                  style: AppTextStyles.subHeader))),
                    ]),
              )
              .toList()
        ]),
      ),
    );
  }
}
