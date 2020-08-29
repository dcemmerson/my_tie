import 'package:flutter/material.dart';

import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_form_attribute.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';

import 'package:my_tie/styles/styles.dart';

class NewFlyFormPublish extends StatefulWidget {
  final _spaceBetweenDropdowns = AppPadding.p6;
  final _animationDuration = const Duration(milliseconds: 500);
  final _initDist = -1.0;
  final _offsetDelta = -1.0;

  @override
  _NewFlyFormPublishState createState() => _NewFlyFormPublishState();
}

class _NewFlyFormPublishState extends State<NewFlyFormPublish>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Animation<Offset>> _offsetAnimations = [];

  NewFlyBloc _newFlyBloc;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: widget._animationDuration, vsync: this)
          ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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

  Widget _buildAttributes(NewFlyFormTransfer nfft) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, AppPadding.p2, 0, AppPadding.p4),
        child: Column(children: [
          Text(nfft.flyInProgress.getAttribute(DbNames.flyName),
              style: AppTextStyles.header),
          ...nfft.newFlyFormTemplate.flyFormAttributes
              .map((FlyFormAttribute attr) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(attr.name, style: AppTextStyles.subHeader),
                  Text(nfft.flyInProgress.getAttribute(attr.name) ?? 'None',
                      style: AppTextStyles.subHeader),
                ]);
          }).toList()
        ]),
      ),
    );
  }

  Widget _buildMaterials(NewFlyFormTransfer nfft) {
    calculateAnimationOffsets(nfft.newFlyFormTemplate);
    List<Widget> rows = [];

    nfft.newFlyFormTemplate.flyFormMaterials.forEach((mat) {
      List<Row> nextRow = [];

      nextRow.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(mat.name, style: AppTextStyles.header)]));

      mat.properties.forEach((k, v) {
        nextRow.add(
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(k, style: AppTextStyles.subHeader),
            Text(nfft.flyInProgress.getMaterial(mat.name, k) ?? 'None selected',
                style: AppTextStyles.subHeader),
          ]),
        );
      });
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
      //mat.name => text widget (eg Furs)
    });

    return Column(
      children: rows,
    );
  }

  List<Widget> _buildFlyFormPreview(NewFlyFormTransfer nfft) {
    return [_buildAttributes(nfft), _buildMaterials(nfft)];
  }

  Widget _buildForm(NewFlyFormTransfer flyFormTransfer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: widget._spaceBetweenDropdowns),
        ..._buildFlyFormPreview(flyFormTransfer),
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
