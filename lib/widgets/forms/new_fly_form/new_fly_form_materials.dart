import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly_material.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/models/form_page_number.dart';
import 'package:my_tie/routes/routes.dart';

import 'package:my_tie/styles/styles.dart';

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

  bool _formChanged = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formPageNumber =
        ModalRoute.of(context).settings.arguments ?? FormPageNumber();
    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;
  }

  void _onFormChanged(Map form) {
    if (!_formChanged) {
      setState(() => _formChanged = true);
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

  void _saveAndValidate(String material) {
    if (_formKey.currentState.saveAndValidate()) {
      var inputs = _formKey.currentState.value;

      var flyMaterials = FlyMaterial(
        name: material,
        props: inputs.map((k, v) => MapEntry(k, v)),
      );
      _newFlyBloc.newFlyMaterialsSink.add(flyMaterials);
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
        FlyMaterialDropdown(
          flyMaterials: flyFormTransfer
              .newFlyFormTemplate.flyFormMaterials[_formPageNumber.pageNumber],
          flyInProgressProperty: null,
        ),
        SizedBox(height: widget._spaceBetweenDropdowns),
        Row(children: [
          RaisedButton(
            child: Text('Next'),
            onPressed: () {
              _saveAndValidate(flyFormTransfer.newFlyFormTemplate
                  .flyFormMaterials[_formPageNumber.pageNumber].name);
              Routes.newFlyMaterialsPage(context,
                  pageNumber: FormPageNumber(
                      pageNumber: _formPageNumber.pageNumber + 1));
            },
          )
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('builldding');
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
                print(snapshot.connectionState);
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
