/// filename: materials_test_manager.dart
/// description: Logic for testing materials aspect of new fly form.
///   Available functionallity includes verify that the materials portion
///   of form was successfully cleared when deleting fly in progress,
///   fill out materials portion of form, verify materials portion, etc.

import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'test_value_keys.dart';

class MaterialsTestManager {
  static const emptyNamePlaceholder = 'No name';
  static const emptyAttributePlaceholder = '[None]';

  static final rnd = Random();

  static final _materials = {
    'beads': {
      'key': TestValueKeys.addBeadsIcon,
      'properties': {
        'color': ['red', 'black', 'tan', 'green', 'beige'],
        'size': ['small', 'medium', 'large'],
        'type': ['lead', 'brass', 'tungsten', 'steel'],
      },
    },
    'dubbings': {
      'key': TestValueKeys.addDubbingsIcon,
      'properties': {
        'color': ['red', 'gray', 'black', 'olive', 'orange'],
      },
    },
    'eyes': {
      'key': TestValueKeys.addEyesIcon,
      'properties': {
        'size': ['small', 'medium', 'large'],
        'type': ['nymph', 'barbell'],
      },
    },
    'feathers': {
      'key': TestValueKeys.addFeathersIcon,
      'properties': {
        'type': ['peacock'],
      },
    },
    'flosses': {
      'key': TestValueKeys.addFlossesIcon,
      'properties': {
        'color': ['red', 'orange'],
      },
    },
  };

  static final MaterialsForTesting materialsForTesting =
      MaterialsForTesting(_materials);

  // Used to maintain list of materials added when running the 'fill out form'
  //  and 'verify materials on form' methods.
  List<TestMaterial> materialsSelected = [];

  // Everytime we instantiate AttributesInfo for integration tests, we will
  //  use rnd to pseudo randomly select fly attributes.
  MaterialsTestManager();

  // static Future verifyAttributesReviewIsCleared(FlutterDriver driver) async {}

  Future fillOutMaterials(FlutterDriver driver) async {
    print('BEGIN ADDING OF MATERIALS');

    // Use materialCount to keep track of the number appended to the end of
    //  ValueKeys used on each subgroup of materials so we can identify different
    //  variations of the same material, eg two beads can be selected and we can
    //  easily verify the properties of each bead separate from one another.
    int materialCount = 0; // Need for this isn't implemented atm (9/9/20),
    //  but may be implemented at a later point.

    await Future.forEach(materialsForTesting.materials,
        (TestMaterial testMaterial) async {
      final addMaterialIcon = find.byValueKey(testMaterial.key);

      await driver.scrollIntoView(addMaterialIcon);
      await driver.tap(addMaterialIcon);
      final testMats = TestMaterial.addedOnScreen(
          key: testMaterial.name + materialCount.toString(),
          name: testMaterial.name,
          propertiesAdded: List<TestProperty>());

      // We are now on the individual 'add material' form.
      await Future.forEach(testMaterial.testProperties,
          (TestProperty testProperty) async {
        final propertySelected = testProperty
            .propertyValues[rnd.nextInt(testProperty.propertyValues.length)];
        await driver.tap(find.byValueKey(testProperty.name));
        await driver.tap(find.text(propertySelected));
        testMats.propertiesAdded.add(
          TestProperty(
              key: testProperty.name + materialCount.toString(),
              name: testProperty.name,
              propertySelected: propertySelected),
        );
      });

      materialsSelected.add(testMats);
      await driver.tap(find.text('Save'));
    });
  }

  Future verifyMaterialsAppearInFormReview(FlutterDriver driver) async {
    print('BEGIN VERIFICATION OF MATERIALS');

    await Future.forEach(materialsSelected, (TestMaterial matSelected) async {
      final ancestor = find.byValueKey(matSelected.key);

      await driver.scrollIntoView(ancestor);
      await Future.forEach(matSelected.propertiesAdded,
          (TestProperty prop) async {
        final searchProp =
            find.descendant(of: ancestor, matching: find.text(prop.name));
        expect(await driver.getText(searchProp), prop.name);
      });
    });
  }

  Future removeEachMaterialAndVerifyRemoved(FlutterDriver driver) async {
    print('BEGIN REMOVAL OF MATERIALS');
    await Future.forEach(materialsSelected, (TestMaterial matSelected) async {
      // Scroll to material

      final ancestor = find.byValueKey(matSelected.key);
      await driver.scrollIntoView(ancestor);

      // Find the edit icon associated with this material and tap. This takes us
      //  to the material edit page.
      final editIcon = find.descendant(
          of: ancestor, matching: find.byType('ReviewEditButton'));
      await driver.tap(editIcon);
      //  Tap delete button on material edit page.
      await driver.tap(find.text('Delete'));

      //  This takes us back to material review page. Verify this material was
      //  indeed removed form review form.
      await Future.forEach(matSelected.propertiesAdded,
          (TestProperty testProp) async {
        expect(
            await isPresent(
                find.descendant(
                    of: ancestor,
                    matching: find.text(testProp.propertySelected)),
                driver),
            false);
      });
    });
  }

  Future<bool> isPresent(SerializableFinder finder, FlutterDriver driver,
      {Duration timeout = const Duration(seconds: 1)}) async {
    try {
      await driver.scrollIntoView(finder, timeout: timeout);
      await driver.waitFor(finder, timeout: timeout);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class MaterialsForTesting {
  final List<TestMaterial> materials;

  MaterialsForTesting(Map<String, Map> mats)
      : materials = _toTestMaterialsList(mats);

  static List<TestMaterial> _toTestMaterialsList(Map<String, Map> mats) {
    List<TestMaterial> matsList = [];
    mats.forEach((key, value) {
      matsList.add(TestMaterial(
          name: key, key: value['key'], properties: value['properties']));
    });

    return matsList;
  }
}

class TestMaterial {
  final String name; // Eg beads, dubbings, eyes, etc.
  // This key is the plus icon button for adding property when used
  // to store list of testProperties, or the ValueKey ref to
  // scroll to this actual material on the review form.
  final String key;
  final List<TestProperty> testProperties;
  final List<TestProperty> propertiesAdded;
//  final Map<String, List<String>> properties;

  TestMaterial({
    this.name,
    this.key,
    this.propertiesAdded,
    Map<String, List<String>> properties,
  }) : testProperties = _toTestPropertiesList(properties);

  TestMaterial.addedOnScreen(
      {this.name, this.key, this.propertiesAdded, this.testProperties});

  static List<TestProperty> _toTestPropertiesList(
      Map<String, List<String>> mats) {
    List<TestProperty> testProps = [];
    mats.forEach((String propName, List<String> propValues) {
      testProps.add(TestProperty(name: propName, propertyValues: propValues));
    });

    return testProps;
  }
}

class TestProperty {
  final String name; // Eg color, size, etc.
  final String key; // This is dropdown key for this property.
  final List<String> propertyValues; // Range of possible values in dropdown.
  final String propertySelected; // Actual value selected from dropdown.

  TestProperty(
      {this.name, this.key, this.propertyValues, this.propertySelected});
}
