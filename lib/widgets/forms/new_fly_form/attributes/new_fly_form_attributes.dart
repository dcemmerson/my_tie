import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_form_attribute.dart';
import 'package:my_tie/models/form_page_number.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/attributes/fly_attribute_dropdown.dart';
import 'package:my_tie/widgets/forms/new_fly_form/attributes/fly_name_text_input.dart';

import '../fly_in_progress_form_stream_builder.dart';

class NewFlyFormAttributes extends StatefulWidget {
  final _spaceBetweenDropdowns = AppPadding.p6;
  @override
  _NewFlyFormAttributesState createState() => _NewFlyFormAttributesState();
}

class _NewFlyFormAttributesState extends State<NewFlyFormAttributes>
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
    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;

    _formPageNumber =
        ModalRoute.of(context).settings.arguments ?? FormPageNumber();
  }

  void _onFormChanged(Map form) {
    if (!_formChanged) {
      _formChanged = true;
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

  bool _saveAndValidate(NewFlyFormTransfer flyFormTransfer) {
    if (_formKey.currentState.saveAndValidate()) {
      Map inputs = _formKey.currentState.value;

      Fly flyInProgress = Fly(
          docId: flyFormTransfer.flyInProgress.docId,
          flyName: inputs[DbNames.flyName],
          attrs: inputs);

      _newFlyBloc.newFlyAttributesSink.add(flyInProgress);
      return true;
    }
    return false;
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  List<Widget> _buildDropdowns(NewFlyFormTransfer flyFormTransfer) {
    return flyFormTransfer.newFlyFormTemplate.flyFormAttributes
        .map((FlyFormAttribute ffa) {
      return FlyAttributeDropdown(
        attribute: ffa.name,
        label: ffa.name,
        flyProperties: ffa.properties,
        flyInProgressProperty:
            flyFormTransfer.flyInProgress.getAttribute(ffa.name),
      );
    }).toList();
  }

  Widget _buildNameInput(String name) {
    return FlyNameTextInput(
      attribute: DbNames.flyName,
      label: 'Fly Name',
      flyInProgressName: name,
    );
  }

  Widget _buildForm(NewFlyFormTransfer flyFormTransfer) {
    return Column(
      //  Must use a key here to disconnect old widget when re-rendering based
      //  on new doc in firestore being fed to streambuilder, otherwise we will
      //  encounter an exception.
      key: UniqueKey(),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNameInput(flyFormTransfer.flyInProgress.flyName),
        SizedBox(height: widget._spaceBetweenDropdowns),
        ..._buildDropdowns(flyFormTransfer),
        SizedBox(height: widget._spaceBetweenDropdowns),
        RaisedButton(
          onPressed: () {
            if (_saveAndValidate(flyFormTransfer)) {
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
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
