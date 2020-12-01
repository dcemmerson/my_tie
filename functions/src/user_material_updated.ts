import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { QueryDocumentSnapshot } from 'firebase-functions/lib/providers/firestore';
import { collections } from './collections';
import { byMaterialsFlies } from './document_fields';

interface Materials {
    [index: string] : Array<object>,
    beads: Array<object>,
    dubbings: Array<object>,
    eyes: Array<object>,
    feathers: Array<object>,
    flosses: Array<object>,
    furs: Array<object>,
    hooks: Array<object>,
    synthetics: Array<object>,
    threads: Array<object>,
    tinsels: Array<object>,
    wires: Array<object>,
    yarns: Array<object>,
}

const db = admin.firestore();
export { userMaterialUpdated };



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

async function deleteUserByMaterialFlies(uid: string): Promise<void> {
    const docsToDelete = await db.collection(collections.byMaterialsFlies).where('uid', '==', uid).get();

    // Can't use map method here, so add each promise to empty array;
    const promises: Promise<FirebaseFirestore.WriteResult>[] = [];
    docsToDelete.forEach(doc => promises.push(doc.ref.delete()));

    await Promise.all(promises);
}

async function deleteMaterialReindexRequests(uid: string): Promise<void> {
    const docsToDelete = await db.collection(collections.materialReindexRequests).where('uid', '==', uid).get();

    // Can't use map method here, so add each promise to empty array.
    const promises: Promise<FirebaseFirestore.WriteResult>[] = [];
    docsToDelete.forEach(doc => promises.push(doc.ref.delete()));
    await Promise.all(promises);
}
function indexFliesByMaterials(uid: string, userMaterials: Materials, flyDocs: QueryDocumentSnapshot[]): Promise<any>[] {

    return flyDocs.map((doc: QueryDocumentSnapshot) => {
        if(doc.exists) {
            const flyMaterials: Materials = doc.data().materials
            const [currMaterialCount, totalMaterialCount] 
                = calcNumMaterialsOnHand(userMaterials, flyMaterials);
            
            return db.collection(collections.byMaterialsFlies).add({
                                                        [byMaterialsFlies.originalFlyDocId]: doc.id,
                                                        ...doc.data(), 
                                                        [byMaterialsFlies.uid]: uid, 
                                                        [byMaterialsFlies.lastIndexed]: Date(),
                                                        [byMaterialsFlies.materialsOnHandCount]: (currMaterialCount as number) / (totalMaterialCount as number), 
                                                    });
        }
        return Promise.resolve();
    });
}

function calcNumMaterialsOnHand(userMaterials: Materials, flyMaterials: Materials): [Number, Number] {
    let userMaterialCount = 0;
    let flyMaterialCount = 0;

    Object.keys(flyMaterials as object).forEach((k: string) => {
        const currFlyMaterial = flyMaterials[k];
        const currUserMaterial = userMaterials[k] as [{[key: string]: any}];

        currFlyMaterial.forEach((material) => {
            flyMaterialCount++;
            const isExactMatch = hasExactUnitMaterialMatch(currUserMaterial, material);
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
