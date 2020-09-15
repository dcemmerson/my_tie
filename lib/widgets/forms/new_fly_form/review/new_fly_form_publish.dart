import 'package:flutter/cupertino.dart';

/// filename: new_fly_form_publish.dart
/// description: Entry widget containg final page for using adding a new fly,
///   before publishing. Allows user to review all fly attributes and materials,
///   as well as provides functionallity to go back and edit that specific
///   property.

import 'package:flutter/material.dart';

import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly.dart';

import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/routes/fly_form_routes.dart';

import 'package:my_tie/styles/styles.dart';

import 'attribute_review.dart';
import 'instruction_review.dart';
import 'material_review.dart';

class NewFlyFormPublish extends StatefulWidget {
  final _spaceBetweenDropdowns = AppPadding.p6;

  @override
  _NewFlyFormPublishState createState() => _NewFlyFormPublishState();
}

class _NewFlyFormPublishState extends State<NewFlyFormPublish> {
  Widget _attributesHeader;
  Widget _materialsHeader;
  Widget _instructionsHeader;

  NewFlyBloc _newFlyBloc;

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
    _instructionsHeader = Container(
        padding: EdgeInsets.all(AppPadding.p2),
        child: Opacity(
            opacity: 0.9,
            child: Text('Instructions',
                style: TextStyle(
                  fontSize: AppFonts.h3,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: TextDecoration.underline,
                ))));
    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;
  }

  void _deleteFlyInProgress(Fly fly) {
    _newFlyBloc.deleteFlyInProgressSink.add(fly);
  }

  void _promptDeleteFlyInProgress(Fly fly) async {
    bool deleteForm = await showDialog<bool>(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: Text('Clear form?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text('Are you sure you want to clear form?')],
              ),
            ),
            actions: [
              FlatButton(
                key: ValueKey('confirmClearFormButton'),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Clear form',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
              FlatButton(
                key: ValueKey('confirmClearFormCancelButton'),
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('Cancel',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryVariant)),
              )
            ],
          );
        });
    if (deleteForm != null && deleteForm) {
      _deleteFlyInProgress(fly);
      Navigator.of(context).pop();
    }
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
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
        MaterialReview(newFlyFormTransfer: flyFormTransfer),
        _instructionsHeader,
        InstructionReview(newFlyFormTransfer: flyFormTransfer),
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
                onPressed: () => print('save not implemented yet...'),
              ),
            ),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FlatButton(
            key: ValueKey('clearFormButton'),
            padding: EdgeInsets.all(0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.delete_forever,
                  color: Theme.of(context).colorScheme.error),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(0, 0, AppPadding.p2, AppPadding.p2),
                child: Text('Clear form',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ]),
            onPressed: () =>
                _promptDeleteFlyInProgress(flyFormTransfer.flyInProgress),
          ),
          FlatButton(
            key: ValueKey('previewFormButton'),
            padding: EdgeInsets.all(0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.art_track,
                  color: Theme.of(context).colorScheme.primary),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(0, 0, AppPadding.p2, AppPadding.p2),
                child: Text('Preview',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
              ),
            ]),
            onPressed: () => FlyFormRoutes.previewPublishPage(context),
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _newFlyBloc.newFlyFormReview,
          builder: (context, AsyncSnapshot<NewFlyFormTransfer> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('error occurred');
            }
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
