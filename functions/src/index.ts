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

exports.addToNewFlyInstruction = functions.firestore.document('/fly_in_progress/{docId}'/*/instructions/instructionDocId'*/)
  .onWrite(async (change, context) => {

    const imageUrisToDelete: Array<string> = extractImageUrlsToDelete(change.after, change.before);
    const storage = admin.storage().bucket(`gs://${BUCKET_URL}`);

    const deletions = imageUrisToDelete.map(async (uri: string) => {
      const file = storage.file(extractImagePathFromUrl(uri));
      return file.delete();
    });

    await Promise.all(deletions);
  });

function extractImagePathFromUrl(url: string) {
  const removedUrl = url.replace(IMAGE_BASE_PATH, '');
  const withSlash = removedUrl.replace('%2F', '/');
  const filePath = withSlash.substring(0, withSlash.lastIndexOf('?'));

  return filePath;

}

function extractImageUrlsToDelete(newDoc: DocumentSnapshot, prevDoc: DocumentSnapshot): Array<string> {
  let urisToRemove: Array<string> = [];
  if (prevDoc.data() && newDoc.data()) {
    // Iterate through all the instruction steps in prevDoc and check if newDoc contains each
    //  image uri in each instruction step. Add each uri not in newDoc instruction steps to
    //  urisToRemove.

    const prevInstructions = prevDoc.data()?.instructions;
    for (const step in prevInstructions) {

      const uris: Array<string> = prevInstructions[step].instruction_image_uris.filter((prevDocUri: string) =>
        !newDoc.data()?.instructions[step].instruction_image_uris.includes(prevDocUri));

      urisToRemove = [...urisToRemove, ...uris];
    }

  }
  return urisToRemove;
}
