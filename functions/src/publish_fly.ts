import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
// import { DocumentSnapshot } from 'firebase-functions/lib/providers/firestore';


const db = admin.firestore();
export { publishFly };

const publishFly = functions.https.onCall(async (data, context) => {
    const flyInProgressDocId: string = data.docId;
    const doc = await db.collection('fly_in_progress').doc(flyInProgressDocId).get();
    const docData = doc.data();

    if (docData !== null && docData !== undefined) {
        await db.collection('fly').add(docData);
    }
    await db.collection('fly_in_progress').doc(flyInProgressDocId).delete();

    //    .set({ fly_is_moved: true, to_be_published: false }, { merge: false });

    return;
});