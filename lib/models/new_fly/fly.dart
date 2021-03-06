import 'package:cloud_firestore/cloud_firestore.dart';

import '../db_names.dart';
import 'new_fly_form_template.dart';
import 'fly_attribute.dart';

/// filename: fly.dart
/// description: Model class representing a fly. A fly has a name, attributes
///   (eg difficulty to tie the fly, type of fly, etc), materials need to tie
///   the fly (eg hook size, threads, etc), and instructional steps to tie
///   the fly.

import 'fly_form_attribute.dart';
import 'fly_form_material.dart';
import 'fly_instruction.dart';
import 'fly_materials.dart';

class Fly {
  static const nullReplacement = '[None]';
  static const nullNameReplacement = '[No name]';
  static const nullDescriptionReplacement = '[No description]';

  final String docId;
  final DocumentSnapshot doc;
  final String flyName;
  final String flyDescription;
  final List<FlyAttribute> attributes;
  final List<FlyMaterials> materials;
  final List<FlyInstruction> instructions;

  final List<String> topLevelImageUris;

  Fly({
    this.docId,
    this.doc,
    this.flyName,
    this.flyDescription,
    List imageUris,
    Map attrs,
    Map mats,
    Map instr,
  })  : this.attributes = _toAttributeList(attrs),
        this.materials = _toMaterialsList(mats),
        this.instructions = _toInstructionsList(instr),
        this.topLevelImageUris = _toListOfString(imageUris);

  Fly.formattedForExhibit({
    this.docId,
    this.doc,
    List imageUris,
    String flyName,
    String flyDescription,
    Map attrs,
    Map mats,
    NewFlyFormTemplate flyFormTemplate,
    Map instr,
  })  : this.flyName =
            flyName ?? nullNameReplacement, // Must set flyName here rather than
        //  default arg (because if value doesnt exist in firebase, flyName will
        //  be explicitly set to null, even if we provide default arg)
        this.flyDescription = flyDescription ?? nullDescriptionReplacement,
        this.attributes =
            _toAttributeListForReview(attrs ?? {}, flyFormTemplate),
        this.materials = _toMaterialListForReview(mats ?? {}, flyFormTemplate),
        this.instructions = _toInstructionsListForReview(instr),
        this.topLevelImageUris = _toListOfString(imageUris);

  /// To format for review, we need to pass in the NewFlyFormTemplate from db,
  ///   which we will then use as a guide to ensure we either set attributes/
  ///   materials values to the value passed in, or Fly.nullReplacement.
  Fly.formattedForReview({
    this.docId,
    this.doc,
    List imageUris,
    String flyName,
    String flyDescription,
    Map attrs,
    Map mats,
    NewFlyFormTemplate flyFormTemplate,
    Map instr,
  })  : this.flyName =
            flyName ?? nullNameReplacement, // Must set flyName here rather than
        //  default arg (because if value doesnt exist in firebase, flyName will
        //  be explicitly set to null, even if we provide default arg)
        this.flyDescription = flyDescription ?? nullDescriptionReplacement,
        this.attributes =
            _toAttributeListForReview(attrs ?? {}, flyFormTemplate),
        this.materials = _toMaterialListForReview(mats ?? {}, flyFormTemplate),
        this.instructions = _toInstructionsListForReview(instr),
        this.topLevelImageUris = _toListOfString(imageUris);

  Fly.formattedForEditing({
    this.docId,
    this.doc,
    this.flyName,
    this.flyDescription,
    List imageUris,
    Map attrs,
    Map mats,
    NewFlyFormTemplate flyFormTemplate,
    Map instr,
  })  : this.attributes =
            _toAttributeListForEditing(attrs ?? {}, flyFormTemplate),
        this.materials = _toMaterialListForEditing(mats ?? {}, flyFormTemplate),
        this.instructions = _toInstructionsList(instr),
        this.topLevelImageUris = _toListOfString(imageUris);

  Map<String, dynamic> toMap() {
    return {
      // DbNames.flyName: flyName,
      DbNames.attributes:
          attributes.asMap().map((k, attr) => attr.toMapEntry()),
      DbNames.materials: materials.asMap().map((k, mat) => mat.toMapEntry()),
      // DbNames.materials: materials.toMap(),
      // DbNames.instructions: instructions.toMap(),
    };
  }

  String getMaterial(
      int materialIndex, int propertyIndex, String propertyName) {
    if ((materialIndex == null ||
            propertyIndex == null ||
            propertyName == null) ||
        propertyIndex >= materials[materialIndex].flyMaterials.length) {
      return null;
    }
    return materials[materialIndex]
        .flyMaterials[propertyIndex]
        .properties[propertyName];
  }

  FlyAttribute get difficulty {
    return attributes.firstWhere(
      (attr) => attr.name == FlyForm.difficulty,
      orElse: () => FlyAttribute(name: FlyForm.difficulty, value: ''),
    );
  }

  List<FlyMaterial> get materialList {
    final materialList = List<FlyMaterial>();
    materials.forEach((matType) {
      if (matType.flyMaterials != null)
        materialList.addAll((matType.flyMaterials));
    });
    return materialList;
  }

  static List<String> _toListOfString(List list) =>
      list?.map((el) => el.toString())?.toList();

  static List<FlyAttribute> _toAttributeListForEditing(
      Map attrs, NewFlyFormTemplate flyFormTemplate) {
    List<FlyAttribute> flyAttributes =
        flyFormTemplate.flyFormAttributes.map((FlyFormAttribute ffa) {
      return FlyAttribute.formattedForEditing(
          name: ffa.name, value: attrs[ffa.name]);
    }).toList();

    return flyAttributes;
  }

  static List<FlyMaterials> _toMaterialListForEditing(
      Map mats, NewFlyFormTemplate flyFormTemplate) {
    List<FlyMaterials> flyMaterials =
        flyFormTemplate.flyFormMaterials.map((FlyFormMaterial ffm) {
      return FlyMaterials.formattedForEditing(
          name: ffm.name, props: mats[ffm.name]);
    }).toList();

    return flyMaterials;
  }

  static List<FlyAttribute> _toAttributeListForReview(
      Map attrs, NewFlyFormTemplate flyFormTemplate) {
    List<FlyAttribute> flyAttributes =
        flyFormTemplate.flyFormAttributes.map((FlyFormAttribute ffa) {
      return FlyAttribute.formattedForReview(
          name: ffa.name, value: attrs[ffa.name]);
    }).toList();

    return flyAttributes;
  }

  static List<FlyMaterials> _toMaterialListForReview(
      Map mats, NewFlyFormTemplate flyFormTemplate) {
    List<FlyMaterials> flyMaterials =
        flyFormTemplate.flyFormMaterials.map((FlyFormMaterial ffm) {
      return FlyMaterials.formattedForReview(
          name: ffm.name, props: mats[ffm.name]);
    }).toList();

    return flyMaterials;
  }

  static List<FlyInstruction> _toInstructionsListForReview(Map instructions) {
    List<FlyInstruction> flyInstructions = [];
    instructions?.forEach(
      (k, instr) => flyInstructions.add(
        FlyInstruction.formattedForReview(instr),
      ),
    );
    flyInstructions.sort(sortBySteps);
    return flyInstructions;
  }

  static List<FlyAttribute> _toAttributeList(Map attrs) {
    List<FlyAttribute> flyAttributes = [];
    attrs
        ?.forEach((k, v) => flyAttributes.add(FlyAttribute(name: k, value: v)));

    return flyAttributes;
  }

  static List<FlyMaterials> _toMaterialsList(Map mats) {
    List<FlyMaterials> flyMaterials = [];
    mats?.forEach((k, v) => flyMaterials.add(FlyMaterials(name: k, props: v)));

    return flyMaterials;
  }

  static List<FlyInstruction> _toInstructionsList(Map instructions) {
    List<FlyInstruction> flyInstructions = [];
    instructions?.forEach(
      (k, instr) => flyInstructions.add(
        FlyInstruction.fromDoc(instr
            // title: instr.title.toString(),
            // description: instr.description.toString(),
            // step: int.parse(instr.step),
            ),
      ),
    );
    flyInstructions.sort(sortBySteps);
    return flyInstructions;
  }

  String getAttribute(String name) => attributes
      .firstWhere((attr) => attr.name == name, orElse: () => null)
      ?.value;

  static int sortBySteps(a, b) {
    if (a.step < b.step)
      return -1;
    else if (a.step == b.step)
      return 0;
    else
      return 1;
  }

  bool get isMaterialsStarted {
    // Check all flyMaterials if user has already entered any materials previously.
    return null !=
        materials.firstWhere(
            (material) =>
                material.flyMaterials != null &&
                material.flyMaterials.length > 0,
            orElse: () => null);
  }

  bool _attributesContainsTerm(String searchTerm) {
    return attributes.any((attr) => attr.containsTerm(searchTerm));
  }

  bool _materialsContainsTerm(String searchTerm) {
    return materials.any((mat) => mat.containsTerm(searchTerm));
  }

  bool _instructionsContainsTerm(String searchTerm) {
    return instructions.any((instr) => instr.containsTerm(searchTerm));
  }

  // args: searchTerm should be user entered search string which has already
  //  been converted to lowercase.
  bool containsTerm(String searchTerm) {
    return flyName.toLowerCase().contains(searchTerm) ||
        flyDescription.toLowerCase().contains(searchTerm) ||
        _attributesContainsTerm(searchTerm) ||
        _materialsContainsTerm(searchTerm) ||
        _instructionsContainsTerm(searchTerm);
  }
}
