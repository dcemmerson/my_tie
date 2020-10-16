import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
// import { DocumentSnapshot } from 'firebase-functions/lib/providers/firestore';


const db = admin.firestore();
export { userSignInFirstTime };

const userSignInFirstTime = functions.auth.user().onCreate(async (user) => {

    return await db.collection('user').add({
        user: user.email,
        name: user.displayName,
        phone_number: user.phoneNumber,
        uid: user.uid,
        materials_on_hand: [],
        favorited_flies: [],
    });
});
