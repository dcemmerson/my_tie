import 'new_fly_form_template.dart';

class FlyFormMaterial {
  final String name;
  final Map<String, List<String>> properties;

  FlyFormMaterial(this.name, Map doc)
      : this.properties = NewFlyFormTemplate.toMapOfLists(doc[name]);
}
