/// filename: test_value_keys.dart
/// description: Static class containg names of ValueKeys used in app,
///   providing accessibility to Flutter Driver in integration tests.

class TestValueKeys {
  static const addNewFlyButton = 'addNewFlyButton';

  //////////////////////////////////////////////////////////////////
  /// Fly in progress review form
  // Attribute related
  static const editAttributesIcon = 'editAttributesIcon';

  static const nameAttributeReview = 'nameAttributeReview';
  static const difficultyAttributeReview = 'difficultyAttributeReview';
  static const styleAttributeReview = 'styleAttributeReview';
  static const typeAttributeReview = 'typeAttributeReview';
  static const targetAttributeReview = 'targetAttributeReview';

  // Buttons at bottom of new fly form
  static const clearFormButton = 'clearFormButton';
  static const confirmClearFormButton = 'confirmClearFormButton';
  static const cancelClearFormButton = 'confirmClearFormCancelButton';

  //////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////
  /// Fly in progress attributes entry
  static const flyNameEntry = 'fly_name';
  static const difficultyAttributeDropdown = 'difficulty';
  static const styleAttributeDropdown = 'style';
  static const typeAttributeDropdown = 'type';
  static const targetAttributeDropdown = 'target';
}
