import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { DocumentSnapshot } from 'firebase-functions/lib/providers/firestore';

admin.initializeApp();
const db = admin.firestore();

const STORAGE_BASE_PATH = 'https://firebasestorage.googleapis.com/v0/b/';
const BUCKET_URL = 'mytie-3b8a3.appspot.com';
const IMAGE_BASE_PATH = STORAGE_BASE_PATH + BUCKET_URL + '/o/';

/// name: addToNewFlyFormTemplate
/// description: Cloud function used to add an attribute or material property
///   to the currently existing newFlyFormTemplate doc.
///   1. Select the latest updated new_fly_form doc.
///   2. Set the last_modified and updated_by fields apprpriately, and 
///     add to new_fly_form as a new doc.
///   3. Merge the value which we are adding to the appropriate nested field.
exports.addToNewFlyFormTemplate = functions.firestore.document('/new_fly_form_incoming/{docId}')
  .onWrite(async (change, context) => {
    if (change.after.data()) {
      const newFlyFormTemplate = 'new_fly_form';

      const prevDoc = await db.collection(newFlyFormTemplate)
        .orderBy('last_modified', 'desc').limit(1).get();
      const prevTemplateData = prevDoc.docs[0].data();
      prevTemplateData.last_modified = new Date();

      // Enforced by our security rules, docId is this user's id.
      prevTemplateData.updated_by = change.after.id;

      const newFormTemplateDoc = await db.collection(newFlyFormTemplate).add(prevTemplateData);

      if (change.after.data()?.attributes) { // Path to add attributes.
        const updateData = change.after.data()?.attributes;
        await db.collection(newFlyFormTemplate).doc(newFormTemplateDoc.id)
          .update({
            ['attributes.' + Object.keys(updateData)[0]]:
              admin.firestore.FieldValue.arrayUnion(Object.values(updateData)[0]),
          });

        return db.collection('new_fly_form_incoming').doc(change.after.id).delete();
      }
      else if (change.after.data()?.materials) { // Path to add materials.
        // change.after.data()?.materials looks something like:
        // {beads: {color: green}}
        const updateData: { [key: string]: { [val: string]: string } } = change.after.data()?.materials;

        // keyTL would be 'beads'
        const keyTL: string = Object.keys(updateData)[0];
        //  keyBL would be 'color'
        const keyBL: string = String(Object.keys(updateData[keyTL])[0]);
        const val: string = updateData[keyTL][keyBL];

        await db.collection(newFlyFormTemplate).doc(newFormTemplateDoc.id)
          .update({
            ['materials.' + keyTL + '.' + keyBL]:
              admin.firestore.FieldValue.arrayUnion(val),
          });

        return db.collection('new_fly_form_incoming').doc(change.after.id).delete();
      }
      else return; // Not a used path
    }
    else {
      // Path to prevent infinite loop.
      return null;
    }
  });

//  name: editNewFlyInstruction
//  description: When writing to a fly in progress doc, we iterate through each
//    instruction to check if the user changed any photos (and the photo urls changed)
//    when updating an instruction. If the old doc contains any urls that are not
//    referenced in the new doc, delete those from storage as they would now
//    be dangling references (from the perspective of the app, but not truly dangling).
//    Additionally, we check the previous doc with the new doc and compare the 
//    top_level_image_uris. Any top_level_image_uris in the old doc but not the new
//    doc will be deleted.
//    
//    Additionally this cloud function calls normalizeInstructionsOrder, which ensures
//    that when user adds/deletes (specifically deletes) instructions, the step numbers
//    self correct themselves. For Example, if user has instruction step 1, 2, and 3, but
//    deletes 2, we need to make sure instruction step 3 is changed to step 2.
exports.editNewFlyInstruction = functions.firestore.document('/fly_in_progress/{docId}')
  .onWrite(async (change, context) => {

    if (instructionsOutOfOrder(change.after)) {
      await normalizeInstructionStepsOrder(change.after);
      return;
    }

    // If fly_is_moved is set to true, this means the fly in progress has been
    //  published by user, effectively moving the fly in progress to the fly_incoming
    //  collection, which would then be validated and moved to the fly collection by admin.
    if (change.after.data()?.fly_is_moved !== true) {
      await cleanupUnusedPhotosFromStorage(change);
    }

    return;

    /// Function definitions for editNewFlyInstruction
    function instructionsOutOfOrder(changedDoc: DocumentSnapshot): boolean {
      const instructions = changedDoc.data()?.instructions;
      let currInstruction = 0;

      for (const [, instruction] of Object.entries(instructions)) {
        currInstruction++;
        const instr = instruction as Instruction;
        if (instr.step_number !== currInstruction) {
          return true;
        }
      }
      return false;
    }

    async function normalizeInstructionStepsOrder(changedDoc: DocumentSnapshot) {
      let currCount = 0;
      const orderedInstructions: { [key: string]: Instruction } = {};
      const changedInstructions = changedDoc.data()?.instructions;
      while (changedInstructions && Object.keys(changedInstructions).length > 0) {
        currCount++;
        // Set minEntry equal to the value of the first key: value entry.
        let minEntry: Instruction = changedInstructions[Object.keys(changedInstructions)[0]];
        for (const [, instruction] of Object.entries(changedInstructions)) {
          const instr = instruction as Instruction;
          if (instr.step_number < minEntry.step_number) {
            minEntry = instr;
          }
        }

        delete changedInstructions[minEntry.step_number.toString()];
        minEntry.step_number = currCount
        orderedInstructions[currCount.toString()] = minEntry;
      }

      // Write orderedInstructions to fly_in_progress doc in db now,
      //  if the order needs to be updated.
      if (orderedInstructions !== changedInstructions) {
        //  delete instructions that were present, followed by inserting the ordered list.
        await db.collection('fly_in_progress').doc(changedDoc.id)
          .set({ 'instructions': admin.firestore.FieldValue.delete() }, { merge: true })
        return db.collection('fly_in_progress').doc(changedDoc.id)
          .set({ 'instructions': orderedInstructions }, { merge: true })
      }
      else return;
    }

    interface Instruction {
      step_number: number // Underscore in naming due to db names.
    }
  }); // End editNewFlyInstructions

async function cleanupUnusedPhotosFromStorage(change: functions.Change<DocumentSnapshot>) {
  const imageUrisToDelete: Array<string> = extractImageUrlsToDelete(change.after, change.before);
  const storage = admin.storage().bucket(`gs://${BUCKET_URL}`);

  const deletions = imageUrisToDelete.map(async (uri: string) => {
    const file = storage.file(extractImagePathFromUrl(uri));
    return file.delete();
  });

  await Promise.all(deletions);
}

function extractImagePathFromUrl(url: string) {
  const removedUrl = url.replace(IMAGE_BASE_PATH, '');
  const withSlash = removedUrl.replace('%2F', '/');
  const filePath = withSlash.substring(0, withSlash.lastIndexOf('?'));

  return filePath;

}

function extractImageUrlsToDelete(newDoc: DocumentSnapshot, prevDoc: DocumentSnapshot): Array<string> {
  // This method could be called in two scenarios where we need to delete images:
  //  1. User deletes an image which was part of an instruction, or a top level
  //    image used in fly overview section.
  //  2. User deletes an entire instruction step which contained 1+ images.
  //  To simulataneously handle both cases, we will collect all image uris from both
  //  prev doc and new doc, then check which (if any) image uris the new doc does not
  //  contain and collect those to be deleted.

  const imageUrisToDelete: Array<string> = [];
  imageUrisToDelete.push(...extractImageUrlsFromInstructionsToDelete());

  imageUrisToDelete.push(...extractTopLevelImageUrlsToDelete());

  return imageUrisToDelete;

  function extractImageUrlsFromInstructionsToDelete(): Array<string> {

    // If no prevDoc, then user just created new fly in progress doc, meaning
    //  there are no old instruction image uris to delete.
    if (!prevDoc.data()?.instructions) return [];
    // else if (newDoc.data()?.instructions) return prevDoc.data()?.instructions;

    const prevInstructions = prevDoc.data()?.instructions;
    const prevInstructionsImageUris: Array<string> = [];

    // Collect image uris from prev and new docs
    for (const step in prevInstructions) {
      prevInstructionsImageUris.push(...prevInstructions[step].instruction_image_uris);
    }

    // If there is no newDoc, then user must have deleted fly in progress form, 
    //  in which case we need to delete all prev image uris from storage.
    if (!newDoc.data()?.instructions) {
      return prevInstructionsImageUris;
    }

    const newInstructions = newDoc.data()?.instructions;
    const newInstructionsImageUris: Array<string> = [];

    for (const step in newInstructions) {
      newInstructionsImageUris.push(...newInstructions[step].instruction_image_uris);
    }

    // Now go through instruction uris in old doc and check if they exist in new doc.
    //  Return all the uris that exist in the old doc, but not the new doc.
    return prevInstructionsImageUris.filter(prevUri => !newInstructionsImageUris.includes(prevUri));
  }

  function extractTopLevelImageUrlsToDelete(): Array<string> {
      
    const prevTopLevelImageUris: Array<string> = prevDoc.data()?.top_level_image_uris;
    const newTopLevelImageUris: Array<string> = newDoc.data()?.top_level_image_uris;

    if (!newTopLevelImageUris) {
      // Case where user deleted entrie doc.
      return prevTopLevelImageUris;
    }
    else if (!prevTopLevelImageUris) {
      return [];
    }
    else {
      return prevTopLevelImageUris.filter(prevUri => !newTopLevelImageUris.includes(prevUri));
    }

  }
}
