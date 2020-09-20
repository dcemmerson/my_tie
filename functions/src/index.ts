import * as admin from 'firebase-admin';

//  Call initializeApp before importing any functions from files.
admin.initializeApp();

import * as newFlyFormIncoming from './new_fly_form_incoming';
import * as editNewFlyInstructions from './edit_new_fly_instructions';

exports.addToNewFlyFormTemplate = newFlyFormIncoming.addToNewFlyFormTemplate;
exports.editNewFlyInstructions = editNewFlyInstructions.editNewFlyInstructions;

