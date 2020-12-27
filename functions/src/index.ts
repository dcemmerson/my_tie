import * as admin from 'firebase-admin';

//  Call initializeApp before importing any functions from files.
admin.initializeApp();

import * as newFlyFormIncoming from './new_fly_form_incoming';
import * as editNewFlyInstructions from './edit_new_fly_instructions';
import { publishFly } from './publish_fly';
import { userSignInFirstTime } from './user_sign_in_first_time';
import { userMaterialUpdated } from './user_material_updated';
import { flyWritten } from './fly';
import { algoliaOnCreate, algoliaOnDelete } from './algolia';

//  Firestore events.
exports.addToNewFlyFormTemplate = newFlyFormIncoming.addToNewFlyFormTemplate;
exports.editNewFlyInstructions = editNewFlyInstructions.editNewFlyInstructions;
exports.userMaterialsUpdated = userMaterialUpdated;
exports.flyWritten = flyWritten;

//  Https callable functions.
exports.publishFly = publishFly;
exports.userSignInFirstTime = userSignInFirstTime;

// Algolia indexing related.
exports.algoliaOnCreate = algoliaOnCreate;
exports.algoliaOnDelete = algoliaOnDelete;

