import * as admin from 'firebase-admin';

//  Call initializeApp before importing any functions from files.
admin.initializeApp();

import * as newFlyFormIncoming from './new_fly_form_incoming';
import * as editNewFlyInstructions from './edit_new_fly_instructions';
import * as publishFly from './publish_fly';
import * as userSignInFirstTime from './user_sign_in_first_time';

//  Firestore events.
exports.addToNewFlyFormTemplate = newFlyFormIncoming.addToNewFlyFormTemplate;
exports.editNewFlyInstructions = editNewFlyInstructions.editNewFlyInstructions;

//  Https callable functions.
exports.publishFly = publishFly.publishFly;
exports.userSignInFirstTime = userSignInFirstTime.userSignInFirstTime;
