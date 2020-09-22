/// filename: db_names.dart
/// last modified: 08/29/2020
/// description: Static class containing the string names which fields are
///   defined as in firestore. Use throughout app to avoid littering string
///   names in app code.

class DbCollections {
  static const flyInProgress = 'fly_in_progress';
  static const fly = 'fly';
  static const flyIncoming = 'fly_incoming';
  static const user = 'user';
}

class DbNames {
  // User collecion related
  static const name = 'name';
  static const uid = 'uid';
  static const phoneNumber = 'phone_number';
  static const user = 'user';
  static const materialsOnHand = 'materials_on_hand';

  // static const fly_is_moved = 'fly_is_moved';
  // static const editable = 'editable';
  static const toBePublished = 'to_be_published';

  // Field names
  static const lastModified = 'last_modified';
  static const uploadedBy = 'uploaded_by';
  static const created = 'created';

  static const attributes = 'attributes';
  static const materials = 'materials';
  static const instructions = 'instructions';
  static const topLevelImageUris = 'top_level_image_uris';

  static const flyName = 'fly_name';
  static const flyDescription = 'fly_description';

  static const flyDifficulty = 'fly_difficulty';
  static const flyDifficulties = 'fly_difficulties';

  static const flyStyle = 'fly_style';
  static const flyStyles = 'fly_styles';

  static const flyTarget = 'fly_target';
  static const flyTargets = 'fly_targets';

  static const flyType = 'fly_type';
  static const flyTypes = 'fly_types';

  static const bead = 'bead';
  static const beads = 'beads';

  static const dubbing = 'dubbing';
  static const dubbings = 'dubbings';

  static const eye = 'eye';
  static const eyes = 'eyes';

  static const feather = 'feather';
  static const feathers = 'feathers';

  static const floss = 'floss';
  static const flosses = 'flosses';

  static const fur = 'fur';
  static const furs = 'furs';

  static const hook = 'hook';
  static const hooks = 'hooks';

  static const synthetic = 'synthetic';
  static const synthetics = 'synthetics';

  static const thread = 'thread';
  static const threads = 'threads';

  static const tinsel = 'tinsel';
  static const tinsels = 'tinsels';

  static const wire = 'wire';
  static const wires = 'wires';

  static const yarn = 'yarn';
  static const yarns = 'yarns';

  static const instructionTitle = 'instruction_title';
  static const instructionStep = 'step_number';
  static const instructionDescription = 'instruction_description';
  static const instructionImageUris = 'instruction_image_uris';
  static const instructionImages = 'instruction_images';
}

class FlyForm {
  static const style = 'style';
  static const difficulty = 'difficulty';
  static const type = 'type';
  static const target = 'target';
}
