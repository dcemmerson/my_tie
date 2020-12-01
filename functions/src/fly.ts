import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import { collections } from './collections';
import { byMaterialsFlies } from './document_fields';


const db = admin.firestore();
export { flyWritten };

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

const flyWritten = functions.firestore
    .document('fly/{userId}')
    .onWrite(async (change, context) => {
        const flyDoc = change.after.data();
        const flyMaterials = flyDoc?.materials;
        const user = await db.collection(collections.user).get();

        // No map method, so push all fly material index queries into promise array, 
        // which we will then wait for all promises.
        const promises: Promise<any>[] = [];
        user.forEach(u => {
            const userMaterials = u.data()?.materials_on_hand;
            if(flyMaterials && userMaterials) {
                const [userMaterialCount, flyMaterialCount] = calcNumMaterialsOnHand(userMaterials as Materials, flyMaterials as Materials);
                const added = db.collection(collections.byMaterialsFlies).add({
                    ...flyDoc,
                    [byMaterialsFlies.lastIndexed]: new Date(),
                    [byMaterialsFlies.materialsOnHandCount]: (userMaterialCount as number) / (flyMaterialCount as number),
                    [byMaterialsFlies.originalFlyDocId]: change.after.id,
                    [byMaterialsFlies.uid]: u.data().uid,
                });
                promises.push(added);
            }
        });

        await Promise.all(promises);
        return;
    });


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

