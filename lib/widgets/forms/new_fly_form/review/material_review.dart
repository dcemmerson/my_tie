/// filename: material_review.dart
/// description: Similar to AttributeReivew.
///   Build Card widget with fly in progress materials to paint
///   on screen for user. We take the NewFlyFormTransfer object, which contains
///   the fly in progress and the fly form template. Find the material fields
///   in fly form template (eg ['color', 'type', 'style', etc]), then
///   search the fly in progress for these matching material values and place
///   in Text widgets.

import 'package:flutter/material.dart';

import 'package:my_tie/models/keys.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/new_fly/form_page_number.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly/new_fly_form_transfer.dart';
import 'package:my_tie/routes/fly_form_routes.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/review/review_edit_button.dart';

class MaterialReview extends StatefulWidget {
  final _iconButtonPadding = 8.0;
  final _semanticLabel = 'Tap to edit';
  final _startMaterials = 'Add fly materials!';
  final _resumeMaterials = 'Pick up where you left off!';

  final _animationDuration = const Duration(milliseconds: 500);
  final _initDist = 0.0;
  final _offsetDelta = -0.5;
  // final _offsetDelta = -1.0;

  final NewFlyFormTransfer nfft;
  final FormFieldState field;

  MaterialReview(
      {@required NewFlyFormTransfer newFlyFormTransfer, @required this.field})
      : nfft = newFlyFormTransfer;

  @override
  _MaterialReviewState createState() => _MaterialReviewState();
}

class _MaterialReviewState extends State<MaterialReview>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Animation<Offset>> _offsetAnimations = [];
  bool _showMaterialsForm = false;

  @override
  void initState() {
    super.initState();

    // Animation related
    _controller =
        AnimationController(duration: widget._animationDuration, vsync: this);
    // ..forward();
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
              begin: Offset(0, offset), end: Offset.zero)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.linear)));

      offset += widget._offsetDelta;
    }
  }

  Widget _buildMaterialHeader(FlyMaterials mat, int index) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        padding: EdgeInsets.all(widget._iconButtonPadding),
        child: Icon(mat.icon),
      ),
      // SizedBox(
      //   width: Theme.of(context).iconTheme.size ??
      //       24 + 4 * widget._iconButtonPadding,
      //   height: Theme.of(context).iconTheme.size ??
      //       24 + 2 * widget._iconButtonPadding,
      // ),
      Row(children: [
        Text(mat.name.toTitleCase(), style: AppTextStyles.header)
      ]),
      IconButton(
        key: ValueKey('${mat.name}AddIcon'),
        onPressed: () => FlyFormRoutes.newFlyMaterialsPage(context,
            pageNumber: FormPageNumber(pageNumber: index)),
        icon: Icon(
          Icons.add,
          semanticLabel: widget._semanticLabel,
        ),
      )
    ]);
  }

  Widget _buildSubGroupHeader(
      FlyMaterial flyMaterial, int materialIndex, int propertyIndex) {
    // SubGroupHeader could be 'Bead 2' for example, with edit icon.
    return Container(
      padding:
          EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, AppPadding.p1),
      alignment: Alignment.bottomLeft,
      child: Row(children: [
        Text(
          flyMaterial.name.toSingular().toTitleCase() +
              ' ' +
              (propertyIndex + 1).toString(),
          style: TextStyle(fontSize: AppFonts.h5, fontWeight: FontWeight.w600),
        ),
        ReviewEditButton(
          onPressedCallback: () => FlyFormRoutes.newFlyMaterialsPage(context,
              pageNumber: FormPageNumber(
                  pageNumber: materialIndex, propertyIndex: propertyIndex)),
          semanticLabel: widget._semanticLabel,
        ),
      ]),
    );
  }

  List<Widget> _buildMaterialSubGroups(
      FlyMaterial flyMaterial, int materialIndex, int propertyIndex) {
    List<Widget> nextSubGroup = [];
    nextSubGroup
        .add(_buildSubGroupHeader(flyMaterial, materialIndex, propertyIndex));

    flyMaterial.properties.forEach((k, v) {
      nextSubGroup.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(k, style: TextStyle(fontSize: AppFonts.h6)),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(v, style: TextStyle(fontSize: AppFonts.h6)),
            ),
          ),
        ]),
      );
    });
    return nextSubGroup;
  }

  Widget _buildShowMaterialsForm() {
    calculateAnimationOffsets(widget.nfft.newFlyFormTemplate);
    _controller.forward();

    // Think of rows as the list of groups of materials, eg beads.
    List<Widget> rows = [];

    widget.nfft.flyInProgress.materials.asMap().forEach((materialIndex, mat) {
      // Think of nextGroup as all of a material type, for example all different
      // types of beads used in this fly.
      List<Widget> nextGroup = [];
      nextGroup.add(_buildMaterialHeader(mat, materialIndex));

      //  Now add each material property in a row to nextRow, for example
      //  Row(children: [Text('color'), Text('red')]) would be a single row entry.
      mat.flyMaterials?.asMap()?.forEach((propertyIndex, flyMaterial) {
        nextGroup.add(Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, AppPadding.p4),
            child: Column(
              //  This value key should be something like 'beads1', which is used
              //  in widget and integration tests to differentiate between potentially
              //  more than one bead, or other material.
              key: ValueKey(flyMaterial.name + propertyIndex.toString()),
              children: _buildMaterialSubGroups(
                  flyMaterial, materialIndex, propertyIndex),
            )));
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
              children: nextGroup,
            ),
          ),
        ),
      ));
    });

    return Column(
      children: rows,
    );
  }

  Widget _buildStartMaterials() {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppPadding.p4),
              child: GestureDetector(
                onTap: () => setState(() => _showMaterialsForm = true),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      key: ValueKey(Keys.startMaterialsKey),
                    ),
                    Text(widget._startMaterials,
                        style: TextStyle(fontSize: AppFonts.h6))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResumeMaterials() {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppPadding.p4),
              child: GestureDetector(
                onTap: () => setState(() => _showMaterialsForm = true),
                child: Row(
                  children: [
                    Icon(
                      Icons.repeat,
                      key: ValueKey(Keys.startMaterialsKey),
                    ),
                    Text(widget._resumeMaterials,
                        style: TextStyle(fontSize: AppFonts.h6))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _showMaterialsForm
          ? _buildShowMaterialsForm()
          : (widget.nfft.flyInProgress.isMaterialsStarted)
              ? _buildResumeMaterials()
              : _buildStartMaterials(),
      if (widget.field.hasError)
        Row(
          children: [
            AppIcons.errorSmall(context),
            Text(widget.field.errorText)
          ],
        )
    ]);
  }
}
