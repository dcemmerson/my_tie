/// filename: new_fly_form_materials.dart
/// last modified: 08/30/2020
/// description: Entry widget used to allow user to choose materials necessary
///   to construct fly. Same widget used for any material, but this widget
///   will add necessary dropdown menus, populated with possible values.

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';

import 'package:my_tie/bloc/state/fly_form_state.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';

import 'package:my_tie/models/bloc_transfer_related/fly_material_add_or_update.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_materials.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/models/form_page_number.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_in_progress_form_stream_builder.dart';

import 'fly_material_dropdown.dart';

class NewFlyFormMaterials extends StatefulWidget {
  final _spaceBetweenDropdowns = AppPadding.p6;

  @override
  _NewFlyFormMaterialsState createState() => _NewFlyFormMaterialsState();
}

class _NewFlyFormMaterialsState extends State<NewFlyFormMaterials>
    with AutomaticKeepAliveClientMixin {
  final _formKey = new GlobalKey<FormBuilderState>();

  NewFlyBloc _newFlyBloc;
  FormPageNumber _formPageNumber;
  bool _showSkipToEnd;

  bool _formChanged = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formPageNumber =
        ModalRoute.of(context).settings.arguments ?? FormPageNumber();
    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;
    _showSkipToEnd = FlyFormStateContainer.of(context).isSkippableToEnd;
  }

  void _onFormChanged(Map form) {
    if (!_formChanged) {
      _formChanged = true;
//      setState(() => _formChanged = true);
    }
  }

  Future<bool> _onWillPop() {
    if (!_formChanged) {
      return Future<bool>.value(true);
    }
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(
            'Are you sure you want to abandon form? Unsaved changes will be lost.'),
        actions: [
          FlatButton(
              child: Text('Abandon'),
              textColor: Colors.red,
              onPressed: () => Navigator.pop(context, true)),
          FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context, false)),
        ],
      ),
    );
  }

  bool _saveAndValidate(Fly fly) {
    if (_formKey.currentState.saveAndValidate()) {
      final inputs = _formKey.currentState.value;

      final FlyMaterial prev = _formPageNumber.propertyIndex == null
          ? null
          : fly.materials[_formPageNumber.pageNumber]
              .flyMaterials[_formPageNumber.propertyIndex];

      final updated = FlyMaterial(
        name: fly.materials[_formPageNumber.pageNumber].name,
        properties: inputs.map((k, v) => MapEntry(k, v)),
      );

      _newFlyBloc.newFlyMaterialSink
          .add(FlyMaterialAddOrUpdate(fly: fly, prev: prev, curr: updated));
      return true;
    }
    return false;
  }

  void _deleteMaterial(Fly fly) {
    final FlyMaterial flyMaterial = _formPageNumber.propertyIndex == null
        ? null
        : fly.materials[_formPageNumber.pageNumber]
            .flyMaterials[_formPageNumber.propertyIndex];
    _newFlyBloc.deleteFlyMaterialSink
        .add(FlyMaterialAddOrUpdate(fly: fly, prev: flyMaterial));
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildForm(NewFlyFormTransfer flyFormTransfer) {
    final Fly fly = flyFormTransfer.flyInProgress;
    final NewFlyFormTemplate flyFormTemplate =
        flyFormTransfer.newFlyFormTemplate;

    return Column(
      //  Must use a key here to disconnect old widget when re-rendering based
      //  on new doc in firestore being fed to streambuilder, otherwise we will
      //  encounter an exception.
      key: UniqueKey(),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: widget._spaceBetweenDropdowns),
        FlyMaterialDropdown(
          flyMaterials:
              flyFormTemplate.flyFormMaterials[_formPageNumber.pageNumber],
          fly: fly,
          formPageNumber: _formPageNumber,
        ),
        SizedBox(height: widget._spaceBetweenDropdowns),
        RaisedButton(
            onPressed: () {
              if (_saveAndValidate(fly)) {
                Navigator.of(context).pop();
              }
            },
            child: Text('Save')),
        if (_formPageNumber.propertyIndex != null)
          // This is indicative that user is editing existing material
          RaisedButton(
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                Navigator.of(context).pop();

                _deleteMaterial(fly);
              },
              child: Text('Delete')),
      ],
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        onChanged: _onFormChanged,
        onWillPop: _onWillPop,
        child: Padding(
            padding: EdgeInsets.all(AppPadding.p2),
            child: FlyInProgressFormStreamBuilder(child: _buildForm)),
      ),
    );
  }
}
