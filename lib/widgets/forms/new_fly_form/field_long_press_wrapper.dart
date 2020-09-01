import 'package:flutter/cupertino.dart';
import 'package:my_tie/models/arguments/add_property_argument.dart';
import 'package:my_tie/routes/fly_form_routes.dart';

class FieldLongPressWrapper extends StatelessWidget {
  final AddPropertyType wrapperType;
  final List<String> properties;
  final BuildContext parentContext;
  final Widget child;
  final String label;
  final String materialName;

  FieldLongPressWrapper({
    @required this.wrapperType,
    @required this.properties,
    @required this.child,
    @required this.label,
    this.materialName: 'fly',
    @required BuildContext context,
  }) : parentContext = context;

  void _attributeOnPressed(BuildContext context) {
    Navigator.of(context).pop();
    // FlyFormRoutes.addNewAttributePage(parentContext,
    //     addAttributeArgument: AddAttributeArgument(
    //       name: label,
    //     ));
  }

  void _materialOnPressed(BuildContext context) {
    Navigator.of(context).pop();
    FlyFormRoutes.addPropertyToFormTemplate(parentContext,
        addPropertyArgument: AddPropertyArgument(
            name: materialName,
            property: label,
            addPropertyType: AddPropertyType.Material));
  }

  void _handleOnPressed(BuildContext context) {
    switch (wrapperType) {
      case (AddPropertyType.Material):
        return _materialOnPressed(context);
      case (AddPropertyType.Attribute):
        return _attributeOnPressed(context);
      default:
        return _materialOnPressed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onLongPress: () => showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          message: Text(
              'Don\'t see the $materialName $label needed for this fly? Go ahead and add it here!'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => _handleOnPressed(context),
              child: Text('Add $label'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel')),
        ),
      ),
    );
  }
}
