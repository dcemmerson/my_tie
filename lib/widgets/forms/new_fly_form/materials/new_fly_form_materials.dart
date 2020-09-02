/// filename: new_fly_form_materials.dart
/// last modified: 08/30/2020
/// description: Entry widget used to allow user to choose materials necessary
///   to construct fly. Same widget used for any material, but this widget
///   will add necessary dropdown menus, populated with possible values.

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/state/fly_form_state.dart';

import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_materials.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/models/form_page_number.dart';

import 'package:my_tie/styles/styles.dart';

import '../../forward_buttons.dart';
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

  bool _saveAndValidate(String material) {
    if (_formKey.currentState.saveAndValidate()) {
      final inputs = _formKey.currentState.value;

      final flyMaterial = FlyMaterial(
        name: material,
        properties: inputs.map((k, v) => MapEntry(k, v)),
      );
      _newFlyBloc.newFlyMaterialSink.add(flyMaterial);
      return true;
    }
    return false;
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
        ),
        SizedBox(height: widget._spaceBetweenDropdowns),
        RaisedButton(
            onPressed: () {
              if (_saveAndValidate(flyFormTemplate
                  .flyFormMaterials[_formPageNumber.pageNumber].name)) {
                Navigator.of(context).pop();
              }
            },
            child: Text('Save')),
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
        ),
      ),
    );
  }
}
