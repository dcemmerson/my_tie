import 'package:flutter_test/flutter_test.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/fly_form_attribute.dart';
import 'package:my_tie/models/fly_form_material.dart';
import 'package:my_tie/models/new_fly_form_template.dart';

const mockNewFlyForm = {
  'attributes': {
    'difficulty': ['easy', 'medium', 'hard'],
    'style': [
      'attractor',
      'caddis',
      'egg',
      'foam',
      'mayfly',
      'midge',
      'streamer',
      'terrestrial',
      'worm',
      'other'
    ],
    'target': ['trout', 'salmon', 'steelhead', 'bass', 'rainbow trout'],
    'type': ['nymph', 'emerger', 'wet fly', 'dry fly', 'other'],
  },
  'materials': {
    'beads': {
      'color': ['red', 'black', 'tan', 'green'],
      'size': ['small', 'medium', 'large'],
      'type': ['lead', 'brass', 'tungsten']
    },
    'dubbings': {
      'color': ['red', 'gray', 'black', 'olive']
    },
    'eyes': {
      'size': ['small', 'medium', 'large'],
      'type': ['nymph', 'barbell']
    },
    'feathers': {
      'type': ['peacock']
    },
    'furs': {
      'type': ['elk hair', 'otter fur']
    },
    'hooks': {
      'size': ['small', 'medium', 'large']
    },
    'synthetics': {
      'type': ['sometype']
    },
    'thread': {
      'color': ['gray', 'black', 'red']
    },
    'tinsels': {
      'color': ['clear', 'pearl', 'black'],
      'type': ['mirage', 'mylar', 'reflective']
    },
    'wires': {
      'color': ['copper', 'gold', 'gray'],
      'type': ['sinker', 'fine']
    },
    'yarns': {
      'color': ['black', 'tan', 'red']
    }
  },
};

void main() {
  group('No fly in progress - ', () {
    test('Fly form template', () {
      // Add the mock data to the NewFlyFormTemplate, then verify all data is
      //  contained in NewFlyFormTemplate.
      final nfft = NewFlyFormTemplate.fromDoc(mockNewFlyForm);
      assert(
          nfft.flyFormAttributes.length == mockNewFlyForm['attributes'].length);
      assert(
          nfft.flyFormMaterials.length == mockNewFlyForm['materials'].length);

      // Check for all attributes
      mockNewFlyForm['attributes'].forEach((key, value) {
        List<FlyFormAttribute> ffas =
            nfft.flyFormAttributes.where((attr) => attr.name == key).toList();
        assert(ffas.length == 1);

        (value as List).forEach((v) {
          assert(ffas[0].properties.contains(v));
        });
      });

      // Check for all materials
      mockNewFlyForm['materials'].forEach((key, value) {
        // eg key == 'beads'

        (value as Map).forEach((k, v) {
          //eg k == 'color', v == List<String>
          List<FlyFormMaterial> ffms =
              nfft.flyFormMaterials.where((mat) => mat.name == key).toList();
          assert(ffms.length == 1);

          List<String> ffmps = ffms[0].properties[k];
          (v as List).forEach((prop) {
            assert(ffmps.contains(prop));
          });
        });
      });
    });
    test('Fly for review', () {
      final nfft = NewFlyFormTemplate.fromDoc(mockNewFlyForm);
      Fly fly = Fly.formattedForReview(flyFormTemplate: nfft);
//      fly.attributes
    });
  });
}
