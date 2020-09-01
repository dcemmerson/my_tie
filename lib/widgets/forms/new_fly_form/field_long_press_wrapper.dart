import 'package:flutter/cupertino.dart';
import 'package:my_tie/models/arguments/add_attribute_argument.dart';
import 'package:my_tie/routes/fly_form_routes.dart';

class FieldLongPressWrapper extends StatelessWidget {
  final List<String> properties;
  final BuildContext parentContext;
  final Widget child;
  final String label;

  FieldLongPressWrapper({
    @required this.properties,
    @required this.child,
    @required this.label,
    @required BuildContext context,
  }) : parentContext = context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onLongPress: () => showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          message: Text(
              'Don\'t see the $label needed for this fly? Go ahead and add it here!'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                FlyFormRoutes.addNewAttributePage(parentContext,
                    addAttributeArgument: AddAttributeArgument(name: label));
              },
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
