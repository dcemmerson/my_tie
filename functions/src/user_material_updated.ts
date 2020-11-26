import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { QueryDocumentSnapshot } from 'firebase-functions/lib/providers/firestore';

interface Materials {
    [index: string] : Array<Object>,
    beads: Array<Object>,
    dubbings: Array<Object>,
    eyes: Array<Object>,
    feathers: Array<Object>,
    flosses: Array<Object>,
    furs: Array<Object>,
    hooks: Array<Object>,
    synthetics: Array<Object>,
    threads: Array<Object>,
    tinsels: Array<Object>,
    wires: Array<Object>,
    yarns: Array<Object>,
    // keys: Function,
}

// interface Attributes {
//     difficulty: string,
//     style: string,
//     target: string,
//     type: string
// }

const db = admin.firestore();
export { userMaterialUpdated };

const collections = {
    byMaterialsFlies: 'by_materials_flies',
    materialReindexRequests: 'material_renidex_requests',
    user: 'user',
}

const userMaterialUpdated = functions.firestore
    .document('material_reindex_requests/{userId}')
    .onWrite(async (change, context) => {
        const uid: string = change.after.data()?.uid;


        if(uid) {
            await deleteMaterialReindexRequests(uid);

            const afterMaterialsDocs = (await db.collection(collections.user).where('uid', '==', uid).get());

            const afterMaterials = afterMaterialsDocs.docs[0]?.data().materials_on_hand;

            await deleteUserByMaterialFlies(uid);
            // Then we need to re-index current user's entries in 
            const flyDocs: FirebaseFirestore.QuerySnapshot<FirebaseFirestore.DocumentData> = await db.collection('fly').get();
            await Promise.all(indexFliesByMaterials(uid, afterMaterials, flyDocs.docs));
        }
    });

async function deleteUserByMaterialFlies(uid: string): Promise<Promise<FirebaseFirestore.WriteResult>[]> {
    const docsToDelete = await db.collection(collections.byMaterialsFlies).where('uid', '==', uid).get();

    // Can't use map method here, so add each promise to empty array;
    const promises: Promise<FirebaseFirestore.WriteResult>[] = [];
    docsToDelete.forEach(doc => promises.push(doc.ref.delete()));

    return promises;
}

async function deleteMaterialReindexRequests(uid: string): Promise<Promise<FirebaseFirestore.WriteResult>[]> {
    const docsToDelete = await db.collection(collections.materialReindexRequests).where('uid', '==', uid).get();

    // Can't use map method here, so add each promise to empty array;
    const promises: Promise<FirebaseFirestore.WriteResult>[] = [];
    docsToDelete.forEach(doc => promises.push(doc.ref.delete()));

    return promises;
}
function indexFliesByMaterials(uid: string, userMaterials: Materials, flyDocs: QueryDocumentSnapshot[]): Promise<any>[] {

    return flyDocs.map((doc: QueryDocumentSnapshot) => {
        if(doc.exists) {
            const flyMaterials: Materials = doc.data().materials
            const [currMaterialCount, totalMaterialCount] 
                = calcNumMaterialsOnHand(userMaterials, flyMaterials);
            console.log("***** we have ");
            console.log(`${currMaterialCount} /  ${totalMaterialCount}`);
            
            return db.collection(collections.byMaterialsFlies).add({
                                                        ...doc.data(), 
                                                        uid: uid, 
                                                        last_indexed: Date(),
                                                        materials_on_hand_count: `${currMaterialCount} /  ${totalMaterialCount}`, 
                                                    });
        }
        return Promise.resolve();
    });
}

function calcNumMaterialsOnHand(userMaterials: Materials, flyMaterials: Materials): [Number, Number] {
    let userMaterialCount = 0;
    let flyMaterialCount = 0;

    Object.keys(flyMaterials as Object).forEach((k: string) => {
        const currFlyMaterial = flyMaterials[k];
        const currUserMaterial = userMaterials[k] as [{[key: string]: any}];

        currFlyMaterial.forEach((material) => {
            flyMaterialCount++;
            const isExactMatch = hasExactUnitMaterialMatch(currUserMaterial, material);
            console.log('exact match = ' + isExactMatch);
            if(isExactMatch) {
                userMaterialCount++;
            }
        });
    });
    return [userMaterialCount, flyMaterialCount];
}

function hasExactUnitMaterialMatch(userMaterials: [{[key: string]: any}], material: {[key: string]: any}): Boolean {
    if(!userMaterials) return false;
    // eg: userMaterials = [{color: "red", size: "small"}, {color: "black", size: "medium", type: "lead"}]
    // eg: material = {"color": green, type: "plastic"}
    const materialKeys = Object.keys(material);

    return userMaterials.reduce((acc: Boolean, curr: {[key: string]: any}): Boolean => {
        let foundMatch = true;
        materialKeys.forEach((k: string) => {

            const flyMat = material[k];
            const userMat = curr[k];
            if(flyMat !== userMat) {
                foundMatch = false;
            }
        });
        return acc || foundMatch;
    }, false);
}

// function deepEquals(before: any, after: any) : Boolean {

//     if(!(before instanceof Array && before instanceof Object) || before === null) {
//         return before === after;
//     }

//     let keys: IterableIterator<any>; 
//     if(after instanceof Array){
//         keys = after.keys();
//     }
//     else {
//         keys = Object.keys(after).values();
//     }
    
//     for(const k of keys) {
//         if(!deepEquals(before[k], after[k])) {
//             return false;
//         }
//     }
//     return true;
// }
