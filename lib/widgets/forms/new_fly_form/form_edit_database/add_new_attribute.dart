import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/edit_new_fly_template_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/arguments/add_attribute_argument.dart';
import 'package:my_tie/models/bloc_related/add_attribute.dart';
import 'package:my_tie/styles/styles.dart';

class AddNewAttribute extends StatefulWidget {
  @override
  _AddNewAttributeState createState() => _AddNewAttributeState();
}

class _AddNewAttributeState extends State<AddNewAttribute> {
  final _formKey = new GlobalKey<FormBuilderState>();
  AddAttributeArgument _addAttributeArgument;
  EditNewFlyTemplateBloc _editNewFlyTemplateBloc;

  bool _formChanged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _editNewFlyTemplateBloc =
        MyTieStateContainer.of(context).blocProvider.editNewFlyTemplateBloc;
    _addAttributeArgument = ModalRoute.of(context).settings.arguments;
  }

  void _onFormChanged() {
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

  bool _saveAndValidate() {
    if (_formKey.currentState.saveAndValidate()) {
      var inputs = _formKey.currentState.value;
      _editNewFlyTemplateBloc.addAttributeSink.add(
        AddAttribute(
          attribute: _addAttributeArgument.name,
          newValue: inputs[_addAttributeArgument.name],
        ),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        onWillPop: _onWillPop,
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p2),
          child: Column(children: [
            Text('Enter new ${_addAttributeArgument.name}',
                style: AppTextStyles.header),
            FormBuilderTextField(
              onChanged: (val) => _onFormChanged(),
              autofocus: true,
              attribute: _addAttributeArgument.name,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(2),
                FormBuilderValidators.maxLength(80)
              ],
              decoration:
                  InputDecoration(labelText: _addAttributeArgument.name),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              RaisedButton(
                onPressed: _saveAndValidate,
                child: Text('Save'),
              ),
              RaisedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text('Cancel'),
              ),
            ]),
          ]),
        ),
      ),
    ));
  }
}
