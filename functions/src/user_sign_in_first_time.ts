import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { collections } from './collections';
// import { DocumentSnapshot } from 'firebase-functions/lib/providers/firestore';


const db = admin.firestore();
export { userSignInFirstTime };

const userSignInFirstTime = functions.auth.user().onCreate(async (user) => {

    // Add document for this user in user collection.
    const userDocRef = await db.collection(collections.user).add({
        user: user.email,
        name: user.displayName,
        phone_number: user.phoneNumber,
        uid: user.uid,
        materials_on_hand: [],
        favorited_flies: [],
    });

    const userDoc = await userDocRef.get();

    // Now add this newly added user's uid to the material_reindex_requests
    // collection which will trigger a fly material reindex for this user.
    await db.collection(collections.materialReindexRequests).add({uid: userDoc.data()?['uid'] : null});

    return;
});
