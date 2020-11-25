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

const userMaterialUpdated = functions.firestore
    .document('user/{userId}')
    .onWrite(async (change, context) => {
        const beforeMaterials: Materials = change.before.data()?.materials_on_hand;
        const afterMaterials: Materials = change.after.data()?.materials_on_hand;

        if(!deepEquals(beforeMaterials, afterMaterials)) {
            // Then we need to re-index current user's entries in 
            const flyDocs: FirebaseFirestore.QuerySnapshot<FirebaseFirestore.DocumentData> = await db.collection('fly').get();
            console.log('!!!fly docs!!!');
            indexFliesByMaterials(afterMaterials, flyDocs.docs);
        }
    });

function indexFliesByMaterials(userMaterials: Materials, flyDocs: QueryDocumentSnapshot[]) {
    console.log('index flies by mats');
    console.log(userMaterials);

    flyDocs.forEach((doc: QueryDocumentSnapshot) => {
        
        if(doc.exists) {
            const flyMaterials: Materials = doc.data().materials
            const [currMaterialCount, totalMaterialCount] 
                = calcNumMaterialsOnHand(userMaterials, flyMaterials);
            console.log("***** we have ");
            console.log(`${currMaterialCount} /  ${totalMaterialCount}`);
        }
    });
}

function calcNumMaterialsOnHand(userMaterials: Materials, flyMaterials: Materials): [Number, Number] {
    let userMaterialCount = 0;
    let flyMaterialCount = 0;

    Object.keys(flyMaterials as Object).forEach((k: string) => {
        const currFlyMaterial = flyMaterials[k];
        const currUserMaterial = userMaterials[k];
    
        currFlyMaterial.forEach((material) => {
            flyMaterialCount++;
            if(hasExactUnitMaterialMatch(currUserMaterial, material)) {
                userMaterialCount++;
            }
        });
    });
    return [userMaterialCount, flyMaterialCount];
}

function hasExactUnitMaterialMatch(userMaterials: Object[], material: Object): Boolean {
    if(!userMaterials) return false;
    // eg: userMaterials = [{color: "red", size: "small"}, {color: "black", size: "medium", type: "lead"}]
    // eg: material = {"color": green, type: "plastic"}
    const materialKeys = Object.keys(material);
    console.log('********************* material keys: ');
    console.log(materialKeys);
    return Object.keys(userMaterials).reduce((acc: Boolean, curr: Object): Boolean => {
        let foundMatch = false;
        materialKeys.forEach((k: string) => {
            // We can safely set default values to null for both cases here
            // as we are guaranteed that material[k] !== null is true.
            const flyMat = material?[k] : null;
            const userMat = curr?[k] : null;
            if(flyMat === userMat) {
                foundMatch = true;
            }
        });
        return acc || foundMatch;
    }, false);
}

function deepEquals(before: any, after: any) : Boolean {

    if(!(before instanceof Array && before instanceof Object) || before === null) {
        return before === after;
    }

    let keys: IterableIterator<any>; 
    if(after instanceof Array){
        keys = after.keys();
    }
    else {
        keys = Object.keys(after).values();
    }
    
    for(const k of keys) {
        if(!deepEquals(before[k], after[k])) {
            return false;
        }
    }
    return true;
}
