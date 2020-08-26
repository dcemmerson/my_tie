import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_attributes.dart';
import 'package:my_tie/models/fly_difficulty.dart';
import 'package:my_tie/models/fly_style.dart';
import 'package:my_tie/models/fly_target.dart';
import 'package:my_tie/models/fly_type.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_attribute_dropdown.dart';
import 'package:my_tie/widgets/forms/new_fly_form/fly_name_text_input.dart';

enum DropdownType { FlyStyles, FlyTypes, Difficulties }
enum Difficulty { Easy, Medium, Hard }

class NewFlyFormAttributes extends StatefulWidget {
  final _spaceBetweenDropdowns = AppPadding.p6;
  @override
  _NewFlyFormAttributesState createState() => _NewFlyFormAttributesState();
}

class _NewFlyFormAttributesState extends State<NewFlyFormAttributes>
    with AutomaticKeepAliveClientMixin {
  final _formKey = new GlobalKey<FormBuilderState>();
  NewFlyBloc _newFlyBloc;

  NewFlyFormTemplate _formTemplate;
  Fly _flyInProgress;

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
    Fly flyInProgress = await _newFlyBloc.flyInProgress;
    print(flyInProgress);
    setState(() => _flyInProgress = flyInProgress);
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

  void _saveAndValidate() {
    if (_formKey.currentState.saveAndValidate()) {
      var inputs = _formKey.currentState.value;
      var flyAtributes = FlyAttributes(
        name: inputs[DbNames.flyName],
        difficulty: FlyDifficulty.fromString(inputs[DbNames.flyDifficulty]),
        style: FlyStyle.fromString(inputs[DbNames.flyStyle]),
        target: FlyTarget.fromString(inputs[DbNames.flyTarget]),
        type: FlyType.fromString(inputs[DbNames.flyType]),
      );
      _newFlyBloc.newFlyAttributesSink.add(flyAtributes);
    }
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
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
          child: _flyInProgress == null || _formTemplate == null
              ? _buildLoading()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FlyNameTextInput(
                        attribute: DbNames.flyName,
                        label: 'Fly Name',
                        flyInProgressName: _flyInProgress?.attributes?.name),
                    SizedBox(height: widget._spaceBetweenDropdowns),
                    FlyAttributeDropdown(
                        attribute: DbNames.flyDifficulty,
                        label: 'Difficulty',
                        flyProperties: _flyInProgress != null
                            ? _formTemplate.flyDifficulties
                            : null,
                        flyInProgressProperty:
                            _flyInProgress?.attributes?.difficulty?.toString()),
                    SizedBox(height: widget._spaceBetweenDropdowns),
                    FlyAttributeDropdown(
                        attribute: DbNames.flyType,
                        label: 'Type',
                        flyProperties: _flyInProgress != null
                            ? _formTemplate.flyTypes
                            : null,
                        flyInProgressProperty:
                            _flyInProgress?.attributes?.type?.toString()),
                    SizedBox(height: widget._spaceBetweenDropdowns),
                    FlyAttributeDropdown(
                        attribute: DbNames.flyStyle,
                        label: 'Style',
                        flyProperties: _flyInProgress != null
                            ? _formTemplate.flyStyles
                            : null,
                        flyInProgressProperty:
                            _flyInProgress?.attributes?.style?.toString()),
                    SizedBox(height: widget._spaceBetweenDropdowns),
                    FlyAttributeDropdown(
                      attribute: DbNames.flyTarget,
                      label: 'Target',
                      flyProperties: _flyInProgress != null
                          ? _formTemplate.flyTargets
                          : null,
                      flyInProgressProperty:
                          _flyInProgress?.attributes?.target?.toString(),
                    ),
                    SizedBox(height: widget._spaceBetweenDropdowns),
                    Row(children: [
                      RaisedButton(
                          onPressed: _saveAndValidate, child: Text('Next'))
                    ]),
                  ],
                ),
        ),
      ),
    );
  }
}
