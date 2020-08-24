import 'package:flutter/material.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_styles_dropdown.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_types_dropdown.dart';

enum DropdownType { FlyStyles, FlyTypes, Difficulties }
enum Difficulty { Easy, Medium, Hard }

class NewFlyForm extends StatefulWidget {
  @override
  _NewFlyFormState createState() => _NewFlyFormState();
}

class _NewFlyFormState extends State<NewFlyForm> {
  final _formKey = new GlobalKey();
  bool _formChanged = false;

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
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            onChanged: _onFormChanged,
            onWillPop: _onWillPop,
            child: Column(
              children: [
                FlyTypesDropdown(),
                FlyStylesDropdown(),
              ],
            )));
  }
}
