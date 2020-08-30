/// filename: new_fly_form_publish.dart
/// description: Entry widget containg final page for using adding a new fly,
///   before publishing. Allows user to review all fly attributes and materials,
///   as well as provides functionallity to go back and edit that specific
///   property.

import 'package:flutter/material.dart';

import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';

import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';

import 'package:my_tie/styles/styles.dart';

import 'attribute_review.dart';

class NewFlyFormPublish extends StatefulWidget {
  final _spaceBetweenDropdowns = AppPadding.p6;
  final _animationDuration = const Duration(milliseconds: 500);
  final _initDist = -1.0;
  final _offsetDelta = -1.0;

  static void popToPage(
      {@required int pageCount,
      @required int popToPage,
      @required BuildContext ctx}) {
    int pagesToPop = pageCount - popToPage;
    for (int i = 0; i < pagesToPop; i++) {
      Navigator.of(ctx).pop();
    }
  }

  @override
  _NewFlyFormPublishState createState() => _NewFlyFormPublishState();
}

class _NewFlyFormPublishState extends State<NewFlyFormPublish>
    with SingleTickerProviderStateMixin {
  Widget _attributesHeader;
  Widget _materialsHeader;
  AnimationController _controller;
  List<Animation<Offset>> _offsetAnimations = [];

  NewFlyBloc _newFlyBloc;

  @override
  void initState() {
    super.initState();

    // Animation related
    _controller =
        AnimationController(duration: widget._animationDuration, vsync: this)
          ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Font related
    _attributesHeader = Container(
        padding: EdgeInsets.all(AppPadding.p2),
        child: Opacity(
            opacity: 0.9,
            child: Text('Attributes',
                style: TextStyle(
                  fontSize: AppFonts.h3,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: TextDecoration.underline,
                ))));
    _materialsHeader = Container(
        padding: EdgeInsets.all(AppPadding.p2),
        child: Opacity(
            opacity: 0.9,
            child: Text('Materials',
                style: TextStyle(
                  fontSize: AppFonts.h3,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: TextDecoration.underline,
                ))));

    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void goToNextPage(NewFlyFormTemplate nfft) {
    // End of form reached.
    print('ended');
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

  /// name: _buildMaterials
  /// description: Similar to _buildAttributes.
  ///   Build Card widget with fly in progress materials to paint
  ///   on screen for user. We take the NewFlyFormTransfer object, which contains
  ///   the fly in progress and the fly form template. Find the material fields
  ///   in fly form template (eg ['color', 'type', 'style', etc]), then
  ///   search the fly in progress for these matching material values and place
  ///   in Text widgets.
  Widget _buildMaterials(NewFlyFormTransfer nfft) {
    calculateAnimationOffsets(nfft.newFlyFormTemplate);
    List<Widget> rows = [];

    nfft.newFlyFormTemplate.flyFormMaterials.forEach((mat) {
      // Add Rows of Text widgets to nextRow, then append nextRow inside
      //  a Card widget.
      List<Row> nextRow = [];

      //  Material name, for example furs, yarns, threads, etc
      nextRow.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(mat.name, style: AppTextStyles.header),
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
                    nfft.flyInProgress.getMaterial(mat.name, k) ??
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

  Widget _buildForm(NewFlyFormTransfer flyFormTransfer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: widget._spaceBetweenDropdowns),
        _attributesHeader,
        AttributeReview(newFlyFormTransfer: flyFormTransfer),
        _materialsHeader,
        _buildMaterials(flyFormTransfer),
        Row(children: [
          Expanded(
            child: Container(
              child: RaisedButton(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, AppPadding.p6, AppPadding.p6, AppPadding.p6),
                    child: Text(
                      'Publish',
                    ),
                  ),
                  Icon(Icons.cloud_upload),
                ]),
                onPressed: () {
                  goToNextPage(flyFormTransfer.newFlyFormTemplate);
                },
              ),
            ),
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _newFlyBloc.newFlyForm,
          builder: (context, AsyncSnapshot<NewFlyFormTransfer> snapshot) {
            if (snapshot.hasError) return Text('error occurred');
            switch (snapshot.connectionState) {
              case (ConnectionState.done):
              case (ConnectionState.active):
                return _buildForm(snapshot.data);
              case (ConnectionState.none):
              case (ConnectionState.waiting):
              default:
                return _buildLoading();
            }
          }),
    );
  }
}
