/// filename: material_review.dart
/// description: Similar to AttributeReivew.
///   Build Card widget with fly in progress materials to paint
///   on screen for user. We take the NewFlyFormTransfer object, which contains
///   the fly in progress and the fly form template. Find the material fields
///   in fly form template (eg ['color', 'type', 'style', etc]), then
///   search the fly in progress for these matching material values and place
///   in Text widgets.

import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/styles/styles.dart';

import 'new_fly_form_publish.dart';

class MaterialReview extends StatefulWidget {
  final _iconButtonPadding = 8.0;
  final _semanticLabel = 'Tap to edit';
  final _animationDuration = const Duration(milliseconds: 500);
  final _initDist = -1.0;
  final _offsetDelta = -1.0;

  final NewFlyFormTransfer nfft;

  MaterialReview({@required NewFlyFormTransfer newFlyFormTransfer})
      : nfft = newFlyFormTransfer;

  @override
  _MaterialReviewState createState() => _MaterialReviewState();
}

class _MaterialReviewState extends State<MaterialReview>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Animation<Offset>> _offsetAnimations = [];

  @override
  void initState() {
    super.initState();

    // Animation related
    _controller =
        AnimationController(duration: widget._animationDuration, vsync: this)
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void calculateAnimationOffsets(NewFlyFormTemplate template) {
    double offset = widget._initDist;
    for (int i = 0; i < template.flyFormMaterials.length; i++) {
      _offsetAnimations.add(Tween<Offset>(
              begin: Offset(offset, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.linear)));

      offset += widget._offsetDelta;
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateAnimationOffsets(widget.nfft.newFlyFormTemplate);
    List<Widget> rows = [];

    widget.nfft.newFlyFormTemplate.flyFormMaterials.forEach((mat) {
      // Add Rows of Text widgets to nextRow, then append nextRow inside
      //  a Card widget.
      List<Row> nextRow = [];

      //  Material name, for example furs, yarns, threads, etc
      nextRow.add(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(
          width:
              Theme.of(context).iconTheme.size + 4 * widget._iconButtonPadding,
          height:
              Theme.of(context).iconTheme.size + 2 * widget._iconButtonPadding,
        ),
        Text(mat.name, style: AppTextStyles.header),
        IconButton(
          onPressed: () => NewFlyFormPublish.popToPage(
              ctx: context,
              pageCount:
                  widget.nfft.newFlyFormTemplate.flyFormMaterials.length + 1,
              popToPage:
                  widget.nfft.newFlyFormTemplate.flyFormMaterials.indexOf(mat) +
                      1),
          icon: Icon(
            Icons.edit,
            semanticLabel: widget._semanticLabel,
          ),
        )
      ]));

      //  Now add each material property in a row to nextRow, for example
      //  Row(children: [Text('color'), Text('red')]) would be a single row entry.
      mat.properties.forEach((k, v) {
        nextRow.add(
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(k, style: AppTextStyles.subHeader),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                    widget.nfft.flyInProgress.getMaterial(mat.name, k) ??
                        'None selected',
                    style: AppTextStyles.subHeader),
              ),
            ),
          ]),
        );
      });

      //  Now build actual card widget with all the previous rows as descendents,
      //  all wrapped in an animation to show card transitioning on screen.
      rows.add(SlideTransition(
        position: _offsetAnimations.removeAt(0),
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
            child: Column(
              children: nextRow,
            ),
          ),
        ),
      ));
    });

    return Column(
      children: rows,
    );
  }
}
