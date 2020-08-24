import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_difficulty_dropdown.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_name_text_input.dart';

import 'package:my_tie/widgets/forms/new_fly_form/fly_styles_dropdown.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_targets_dropdown.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_types_dropdown.dart';

enum DropdownType { FlyStyles, FlyTypes, Difficulties }
enum Difficulty { Easy, Medium, Hard }

class NewFlyForm extends StatefulWidget {
  final _spaceBetweenDropdowns = AppPadding.p6;
  @override
  _NewFlyFormState createState() => _NewFlyFormState();
}

class _NewFlyFormState extends State<NewFlyForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = new GlobalKey<FormBuilderState>();
  bool _formChanged = false;

  @override
  bool get wantKeepAlive => true;

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
//        onChanged: _onFormChanged,
        onWillPop: _onWillPop,
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlyNameTextInput(),
              SizedBox(height: widget._spaceBetweenDropdowns),
              FlyDifficultyDropdown(),
              SizedBox(height: widget._spaceBetweenDropdowns),
              FlyTypesDropdown(),
              SizedBox(height: widget._spaceBetweenDropdowns),
              FlyStylesDropdown(),
              SizedBox(height: widget._spaceBetweenDropdowns),
              FlyTargetsDropdown(),
              SizedBox(height: widget._spaceBetweenDropdowns),
              Row(children: [
                RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.saveAndValidate()) {
                        print(_formKey.currentState.value);
                      }
                    },
                    child: Text('Next'))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
