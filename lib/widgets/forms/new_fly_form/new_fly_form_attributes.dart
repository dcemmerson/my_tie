import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/bloc/new_fly_bloc.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_attribute.dart';
import 'package:my_tie/models/fly_difficulty.dart';
import 'package:my_tie/models/fly_form_attribute.dart';
import 'package:my_tie/models/form_page_number.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/routes/routes.dart';
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
      List<FlyAttribute> flyAttributes = [];
      inputs.forEach(
          (k, v) => flyAttributes.add(FlyAttribute(name: k, value: v)));

      _newFlyBloc.newFlyAttributesSink.add(flyAttributes);
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
            flyFormTransfer.flyInProgress.getAttribute(ffa.name).toString(),
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

  void goToNextPage(NewFlyFormTemplate nfft) {
    Routes.newFlyMaterialsPage(context,
        pageNumber: FormPageNumber(
          pageNumber: _formPageNumber.pageNumber + 1,
          pageCount: nfft.flyFormMaterials.length,
        ));
  }

  Widget _buildForm(NewFlyFormTransfer flyFormTransfer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNameInput(
            flyFormTransfer.flyInProgress.getAttribute(DbNames.flyName)),
        SizedBox(height: widget._spaceBetweenDropdowns),
        ..._buildDropdowns(flyFormTransfer),
        SizedBox(height: widget._spaceBetweenDropdowns),
        Row(children: [
          RaisedButton(
            child: Text('Next'),
            onPressed: () {
              if (_saveAndValidate()) {
                goToNextPage(flyFormTransfer.newFlyFormTemplate);
              }
            },
          )
        ]),
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
