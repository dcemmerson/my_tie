/// filename: fly_material_add_or_update.dart
/// last modified: 09/06/2020
/// description: Helper class used for adding/updating new fly material to fly
///   to fly material form when user is addding a new fly to db.

import '../fly.dart';
import '../fly_materials.dart';

class FlyMaterialAddOrUpdate {
  final Fly fly;
  final FlyMaterial prev;
  final FlyMaterial curr;

  FlyMaterialAddOrUpdate({this.fly, this.prev, this.curr});
}
