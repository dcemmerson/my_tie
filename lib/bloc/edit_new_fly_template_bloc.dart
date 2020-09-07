import 'dart:async';

import 'package:my_tie/models/bloc_transfer_related/add_attribute.dart';
import 'package:my_tie/models/bloc_transfer_related/add_material.dart';
import 'package:my_tie/services/network/auth_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

/// filename: edit_new_fly_template_bloc.dart
/// last modified: 08/30/2020
/// description: New fly template BLoC class. Business logic class for user
///   adding a new properties (material types, attributes, etc) to database, in
///   the process of uploading a new fly. This class stands between the app
///   (the actual add to fly template forms, and service to firestore, in
///   fly_template_service.dart). This class provides our app with streams and
///   sinks to read and add fly template data from firestore.

class EditNewFlyTemplateBloc {
  final FlyFormTemplateService flyFormTemplateService;
  final AuthService authService;

  StreamController<AddAttribute> addAttributeSink =
      StreamController<AddAttribute>();
  StreamController<AddMaterial> addMaterialSink =
      StreamController<AddMaterial>();

  EditNewFlyTemplateBloc({this.flyFormTemplateService, this.authService}) {
    addAttributeSink.stream.listen(_handleAddAttributeToFormTemplate);
    addMaterialSink.stream.listen(_handleAddMaterialToFormTemplate);
  }

  Future _handleAddAttributeToFormTemplate(AddAttribute addAttribute) {
    flyFormTemplateService.addAttributeToFormTemplate(
      uid: authService.currentUser.uid,
      attribute: addAttribute.attribute,
      value: addAttribute.newValue,
    );
    return null;
  }

  Future _handleAddMaterialToFormTemplate(AddMaterial addMaterial) {
    flyFormTemplateService.addMaterialToFormTemplate(
      uid: authService.currentUser.uid,
      material: addMaterial.materialName,
      property: addMaterial.property,
      value: addMaterial.newValue,
    );
    return null;
  }

  void close() {
    addAttributeSink.close();
    addMaterialSink.close();
  }
}
