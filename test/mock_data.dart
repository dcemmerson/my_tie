class MockData {
  static const mockNewFlyFormDoc = {
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

  static const flyInProgressDoc = {
    'fly_name': 'Marclar',
    'materials': {
      'beads': [
        {'color': 'red', 'size': 'small', 'type': 'steel'},
        {'color': 'black', 'size': 'mediun', 'type': 'lead'}
      ],
      'hooks': [
        {'size': 'medium'}
      ],
      'wires': [
        {'color': 'copper', 'type': 'sinker'}
      ],
      'yarns': [
        {'color': 'tan'},
        {'color': 'black'}
      ]
    },
    'attributes': {
      // 'fly_name': 'my new fly name',
      'difficulty': 'medium',
      'style': 'caddis',
      'target': 'steelhead',
      'type': 'nymph',
    },
  };
}
