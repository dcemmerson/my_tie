import * as functions from 'firebase-functions';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.addUidToFlyInProgress = functions.firestore
    .document('fly_in_progress/{doc-id}')
    .onWrite((change, context) => {
        const uid = context.auth?.uid;
        if(uid === null) return;
        return change.after.ref.update({uid: uid});
    });