import 'package:flutter/material.dart';
import 'package:my_tie/widgets/forms/new_fly_form/attributes/new_fly_form_attributes.dart';

class NewFlyAttributesPage extends StatelessWidget {
  static const title = 'Fly Attributes';
  static const route = '/new_fly/attributes';

  @override
  Widget build(BuildContext context) {
    return NewFlyFormAttributes();
  }
}
