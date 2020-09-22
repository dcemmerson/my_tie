import 'package:flutter_test/flutter_test.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/fly_attribute.dart';
import 'package:my_tie/models/new_fly/fly_form_attribute.dart';
import 'package:my_tie/models/new_fly/fly_form_material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';

import 'mock_data.dart';

void main() {
  group('Fly miscellaneous - ', () {
    test('Test isMaterialsStarted', () {
      Fly fly = Fly();
      assert(fly.isMaterialsStarted == false);

      fly.materials.add(FlyMaterials(name: 'faked', props: [
        {'color': 'red', 'size': 'small'}
      ]));

      assert(fly.isMaterialsStarted == true);
    });
  });

  group('Fly form template - ', () {
    NewFlyFormTemplate nfft;
    Fly fly;
    setUp(() {
      nfft = NewFlyFormTemplate.fromDoc(MockData.mockNewFlyFormDoc);
      fly = Fly.formattedForReview(flyFormTemplate: nfft);
    });

    test('Test fly form template without fly', () {
      // Add the mock data to the NewFlyFormTemplate, then verify all data is
      //  contained in NewFlyFormTemplate.
      assert(nfft.flyFormAttributes.length ==
          MockData.mockNewFlyFormDoc['attributes'].length);
      assert(nfft.flyFormMaterials.length ==
          MockData.mockNewFlyFormDoc['materials'].length);

      // Check for all attributes
      MockData.mockNewFlyFormDoc['attributes'].forEach((key, value) {
        final List<FlyFormAttribute> ffas =
            nfft.flyFormAttributes.where((attr) => attr.name == key).toList();
        assert(ffas.length == 1);

        (value as List).forEach((v) {
          assert(ffas[0].properties.contains(v));
        });
      });

      // Check for all materials
      MockData.mockNewFlyFormDoc['materials'].forEach((key, value) {
        // eg key == 'beads'

        (value as Map).forEach((k, v) {
          //eg k == 'color', v == List<String>
          final List<FlyFormMaterial> ffms =
              nfft.flyFormMaterials.where((mat) => mat.name == key).toList();
          assert(ffms.length == 1);

          List<String> ffmps = ffms[0].properties[k];
          (v as List).forEach((prop) {
            assert(ffmps.contains(prop));
          });
        });
      });
    });
  });
  group('No fly in progress - ', () {
    NewFlyFormTemplate nfft;
    Fly fly;
    setUp(() {
      nfft = NewFlyFormTemplate.fromDoc(MockData.mockNewFlyFormDoc);
      fly = Fly.formattedForReview(flyFormTemplate: nfft);
    });

    test('Fly for review, test attributes', () {
      MockData.mockNewFlyFormDoc['attributes'].forEach((attrKey, attrValues) {
        FlyAttribute flyAttribute = fly.attributes.firstWhere(
            (flyAttribute) => flyAttribute.name == attrKey,
            orElse: () => null);
        assert(flyAttribute != null);
        assert(flyAttribute.value == '[None]');
      });
    });
    test('Fly for review, test materials', () {
      MockData.mockNewFlyFormDoc['materials'].forEach((matKey, matValues) {
        // eg matKey == 'beads'
        FlyMaterials flyMaterials = fly.materials.firstWhere(
            (flyMaterials) => flyMaterials.name == matKey,
            orElse: () => null);

        assert(flyMaterials != null);
        // There is no fly in progress, so flyMaterials.flyMaterials should
        //  be null.
        assert(flyMaterials.flyMaterials == null);
      });
    });
    test('Fly for review, test instructions', () {
      assert(fly.instructions != null);
      assert(fly.instructions.length == 0);
    });
  });
  group('With fly in progress - ', () {
    NewFlyFormTemplate nfft;
    Fly fly;
    setUp(() {
      nfft = NewFlyFormTemplate.fromDoc(MockData.mockNewFlyFormDoc);
      fly = Fly.formattedForReview(
          flyFormTemplate: nfft,
          attrs: MockData.flyInProgressDoc['attributes'],
          mats: MockData.flyInProgressDoc['materials'],
          instr: MockData.flyInProgressDoc['instructions']);
    });

    test('Fly for review, test attributes', () {
      (MockData.flyInProgressDoc['attributes'] as Map)
          .forEach((attrKey, attrValue) {
        // eg, attrKey == 'difficulty', attrValue == 'medium'
        FlyAttribute foundFlyAttribute = fly.attributes.firstWhere(
          (flyAttr) => flyAttr.name == attrKey && flyAttr.value == attrValue,
          orElse: () => null,
        );
        assert(foundFlyAttribute != null);
      });
    });
    test('Fly for review, test materials', () {
      (MockData.flyInProgressDoc['materials'] as Map)
          .forEach((matKey, matValues) {
        // eg, matKey == 'beads
        (matValues as List).forEach((matProps) {
          // eg, matProps == {'color': 'red', 'size': 'small', 'type': 'steel'},
          FlyMaterials flyMaterials = fly.materials.firstWhere(
            (flyMat) => flyMat.name == matKey,
            orElse: () => null,
          );

          assert(flyMaterials != null);

          matProps.forEach((key, value) {
            // eg, key == 'color', value == 'red'
            FlyMaterial foundFlyMaterial = flyMaterials.flyMaterials.firstWhere(
                (flyMat) =>
                    flyMat.properties.containsKey(key) &&
                    flyMat.properties.containsValue(value),
                orElse: () => null);

            assert(foundFlyMaterial != null);
          });
        });
      });
    });
  });
}
