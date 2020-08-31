import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/fly_form_state.dart';
import 'package:my_tie/models/form_page_number.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/routes/fly_form_routes.dart';

typedef SaveAndValidate = bool Function();

class ForwardButtons extends StatelessWidget {
  final SaveAndValidate saveAndValidate;
  final FormPageNumber formPageNumber;
  final NewFlyFormTransfer flyFormTransfer;

  ForwardButtons(
      {@required this.saveAndValidate,
      @required this.formPageNumber,
      @required this.flyFormTransfer});

  @override
  Widget build(BuildContext context) {
    bool showSkipToEnd = FlyFormStateContainer.of(context).isSkippableToEnd;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      RaisedButton(
        child: Text('Next'),
        onPressed: () {
          if (saveAndValidate()) {
            FlyFormRoutes.goToNextPage(
                context: context,
                formPageNumber: formPageNumber,
                newFlyFormTemplate: flyFormTransfer.newFlyFormTemplate);
          }
        },
      ),
      !showSkipToEnd
          ? SizedBox(height: 0, width: 0)
          : FlatButton(
              child:
                  Row(children: [Text('Skip to end'), Icon(Icons.skip_next)]),
              onPressed: () {
                if (saveAndValidate()) {
                  FlyFormRoutes.skipToEnd(
                    context: context,
                    formPageNumber: formPageNumber,
                    newFlyFormTemplate: flyFormTransfer.newFlyFormTemplate,
                  );
                }
              },
            )
    ]);
  }
}
