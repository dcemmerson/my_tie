import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/fly_attributes.dart';
import 'package:my_tie/models/fly_difficulty.dart';
import 'package:my_tie/models/fly_style.dart';
import 'package:my_tie/models/fly_target.dart';
import 'package:my_tie/models/fly_type.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
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
  NewFlyBloc _newFlyBloc;

  NewFlyFormTemplate _formTemplate;
  Map _flyInProgress;

  bool _formChanged = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;
    if (_formTemplate == null) {
      _fetchAttributes();
    }
    if (_flyInProgress == null) {
      _fetchFlyInProgress();
    }
  }

  void _fetchAttributes() async {
    NewFlyFormTemplate formTemplate = await _newFlyBloc.newFlyForm;
    setState(() => _formTemplate = formTemplate);
  }

  void _fetchFlyInProgress() async {
    Map flyInProgress = (await _newFlyBloc.flyInProgress).data();
    setState(() => _flyInProgress = flyInProgress);
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

  void _saveAndValidate() {
    if (_formKey.currentState.saveAndValidate()) {
      var inputs = _formKey.currentState.value;
      var flyAtributes = FlyAttributes(
        name: inputs['flyName'],
        difficulty: FlyDifficulty(inputs['flyDifficulty']),
        style: FlyStyle(inputs['flyStyle']),
        target: FlyTarget(inputs['flytarget']),
        type: FlyType(inputs['flyType']),
      );
      _newFlyBloc.newFlyAttributesSink.add(flyAtributes);
    }
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
              FlyDifficultyDropdown(
                flyDifficulties: _flyInProgress != null
                    ? _formTemplate.flyDifficulties
                    : null,
              ),
              SizedBox(height: widget._spaceBetweenDropdowns),
              FlyTypesDropdown(
                flyTypes:
                    _flyInProgress != null ? _formTemplate.flyTypes : null,
              ),
              SizedBox(height: widget._spaceBetweenDropdowns),
              FlyStylesDropdown(
                flyStyles:
                    _flyInProgress != null ? _formTemplate.flyStyles : null,
              ),
              SizedBox(height: widget._spaceBetweenDropdowns),
              FlyTargetsDropdown(
                flyTargets:
                    _flyInProgress != null ? _formTemplate.flyTargets : null,
              ),
              SizedBox(height: widget._spaceBetweenDropdowns),
              Row(children: [
                RaisedButton(onPressed: _saveAndValidate, child: Text('Next'))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
