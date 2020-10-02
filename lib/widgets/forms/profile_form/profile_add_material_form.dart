import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/user_bloc.dart';
import 'package:my_tie/models/bloc_transfer_related/user_profile_fly_material_add_or_delete.dart';
import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/string_format.dart';

import 'package:my_tie/widgets/forms/new_fly_form/materials/fly_material_dropdown.dart';

class ProfileAddMaterialForm extends StatefulWidget {
  final FlyFormMaterial flyFormMaterial;
  final UserProfile userProfile;
  final _spaceBetweenDropdowns = AppPadding.p6;

  ProfileAddMaterialForm({this.flyFormMaterial, this.userProfile});

  @override
  _ProfileAddMaterialFormState createState() => _ProfileAddMaterialFormState();
}

class _ProfileAddMaterialFormState extends State<ProfileAddMaterialForm> {
  final _formKey = new GlobalKey<FormBuilderState>();
  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userBloc = MyTieStateContainer.of(context).blocProvider.userBloc;
  }

  bool _saveAndValidate() {
    print('contains = ');
    print(widget.userProfile.contains(
        name: widget.flyFormMaterial.name,
        properties: _formKey.currentState.value));
    if (_formKey.currentState.saveAndValidate() &&
        !widget.userProfile.contains(
            name: widget.flyFormMaterial.name,
            properties: _formKey.currentState.value)) {
      _userBloc.addUserFlyMaterialSink.add(
          UserProfileFlyMaterialAddOrDelete.fromMap(_formKey.currentState.value,
              name: widget.flyFormMaterial.name,
              userProfile: widget.userProfile));
      _showSuccessSnackBar();
      return true;
    }
    return false;
  }

  void _showSuccessSnackBar() {
    final snackBar = SnackBar(content: Text('Material added!'));

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showExistsSnackBar() {
    final snackBar =
        SnackBar(content: Text('Material already exists in profile.'));

    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget _buildForm() {
    return Column(
      //  Must use a key here to disconnect old widget when re-rendering based
      //  on new doc in firestore being fed to streambuilder, otherwise we will
      //  encounter an exception.
      key: UniqueKey(),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlyMaterialDropdown(flyFormMaterial: widget.flyFormMaterial),
        SizedBox(height: widget._spaceBetweenDropdowns),
        RaisedButton(
            onPressed: () {
              if (_saveAndValidate()) {
                print('success');
                // Navigator.of(context).pop();
              }
            },
            child: Text(
                'Add ${widget.flyFormMaterial.name.toSingular().toTitleCase()}')),
        //   if (_formPageNumber?.propertyIndex != null)
        //     // This is indicative that user is editing existing material
        //     RaisedButton(
        //         color: Theme.of(context).colorScheme.error,
        //         onPressed: () {
        //           Navigator.of(context).pop();

        //           _deleteMaterial(fly);
        //         },
        //         child: Text('Delete')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        // onChanged: _onFormChanged,
        // onWillPop: _onWillPop,
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p2),
          child: _buildForm(),
        )
        // Padding(
        //   padding: EdgeInsets.all(AppPadding.p2),
        //   child: FlyMaterialDropdown(
        //     flyFormMaterial: widget.flyFormMaterial,
        //   ),
        // ),
        );
  }
}
