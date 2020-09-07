/// filename: new_fly_form_instruction.dart
/// last modified: 09/03/2020
/// description: Widget for adding additional instructions to how to tie a new
///   fly that user is inputting into db. This widget expects an instance of
///   InstructionPageAttribute to be passed in via the route, which we use
///   to know which step number the user is either editting or adding to db.

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/arguments/instruction_page_attribute.dart';
import 'package:my_tie/models/bloc_transfer_related/fly_instruction_change.dart';
import 'package:my_tie/models/bloc_transfer_related/fly_instruction_transfer.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_instruction.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/instructions/instruction_name_text_input.dart';

import '../fly_in_progress_instruction_step_stream_builder.dart';
import 'instruction_description_text_input.dart';
import 'instruction_photo_input.dart';

class NewFlyFormInstruction extends StatefulWidget {
  @override
  _NewFlyFormInstructionState createState() => _NewFlyFormInstructionState();
}

class _NewFlyFormInstructionState extends State<NewFlyFormInstruction> {
  final _formKey = new GlobalKey<FormBuilderState>();
  NewFlyBloc _newFlyBloc;
  InstructionPageAttribute _instructionPageAttribute;
  bool _formChanged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _newFlyBloc = MyTieStateContainer.of(context).blocProvider.newFlyBloc;
    _instructionPageAttribute = ModalRoute.of(context).settings.arguments;
  }

  void _onChanged() {
    if (!_formChanged) {
      // setState(() => _formChanged = true);
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

  bool _saveAndValidate(FlyInstructionTransfer flyInstructionTransfer) {
    if (_formKey.currentState.saveAndValidate()) {
      final inputs = {
        ..._formKey.currentState.value,
        DbNames.instructionStep: _instructionPageAttribute.stepNumber
      };

      _newFlyBloc.newFlyInstructionSink.add(FlyInstructionChange(
          fly: flyInstructionTransfer.fly,
          prevInstruction: flyInstructionTransfer.flyInstruction,
          updatedInstruction: inputs));
      return true;
    }
    return false;
  }

  void _deleteInstruction(FlyInstructionTransfer flyInstructionTransfer) {
    _newFlyBloc.deleteFlyInstructionSink.add(flyInstructionTransfer);
  }

  Widget _buildTitle() => Container(
      alignment: Alignment.center,
      child: Text('Step ${_instructionPageAttribute.stepNumber}',
          style: AppTextStyles.header));

  Widget _buildForm(FlyInstructionTransfer flyInstructionTransfer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(),
        InstructionNameTextInput(
          attribute: DbNames.instructionTitle,
          initialValue: flyInstructionTransfer.flyInstruction.title,
          label: 'Enter Title',
        ),
        InstructionDescriptionTextInput(
            attribute: DbNames.instructionDescription,
            initialValue: flyInstructionTransfer.flyInstruction.description,
            label: 'Enter Description'),
        SizedBox(height: AppPadding.p5),
        InstructionPhotoInput(
          attribute: DbNames.instructionImages,
          imageUris: flyInstructionTransfer.flyInstruction.imageUris,
          label: 'Choose photos',
        ),
        RaisedButton(
          onPressed: () {
            if (_saveAndValidate(flyInstructionTransfer)) {
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        ),
        if (flyInstructionTransfer.flyInstruction.step != null)
          //  Indicates this user is editting an instruction.
          RaisedButton(
            color: Theme.of(context).colorScheme.error,
            onPressed: () {
              _deleteInstruction(flyInstructionTransfer);
              Navigator.of(context).pop();
            },
            child: Text('Delete this step'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        onChanged: (e) => _onChanged,
        onWillPop: _onWillPop,
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p2),
          child: FlyInProgressInstructionStepStreamBuilder(
              instructionPageAttribute: _instructionPageAttribute,
              child: _buildForm),
        ),
      ),
    );
  }
}
