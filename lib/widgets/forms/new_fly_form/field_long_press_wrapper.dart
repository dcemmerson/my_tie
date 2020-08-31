import 'package:flutter/cupertino.dart';

class FieldLongPressWrapper extends StatelessWidget {
  final Widget child;
  final String label;

  FieldLongPressWrapper({@required this.child, @required this.label});

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
              onPressed: () => print('Add $label'),
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
