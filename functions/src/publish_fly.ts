import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


const db = admin.firestore();
export { publishFly };

const publishFly = functions.https.onCall(async (data, context) => {
    const flyInProgressDocId: string = data.docId;
    const doc = await db.collection('fly_in_progress').doc(flyInProgressDocId).get();
    const docData = doc.data();

    if (docData !== null && docData !== undefined && validate(docData)) {
        await db.collection('fly').add(docData);
        await db.collection('fly_in_progress').doc(flyInProgressDocId).delete();
    }

    return;
});

function validate(doc: FirebaseFirestore.DocumentData): boolean {
    return isFlyAttributesValid(doc.attributes) && isFlyMaterialsValid(doc.materials)
        && isFlyInstructionsValid(doc.instructions);

    // Ensure all attribute properties contain some value.
    function isFlyAttributesValid(attributes: Attributes): boolean {
        return !(isEmptyString(attributes.difficulty) || isEmptyString(attributes.style)
            || isEmptyString(attributes.target) || isEmptyString(attributes.type));
    }

    function isEmptyString(prop: string): boolean {
        return (prop === null || prop === undefined || prop === '');
    }

    // Ensure there are one or more required materials for fly.
    function isFlyMaterialsValid(materials: Materials) {
        return !isEmptyObject(materials.beads) || !isEmptyObject(materials.dubbings)
            || !isEmptyObject(materials.eyes) || !isEmptyObject(materials.feathers)
            || !isEmptyObject(materials.flosses) || !isEmptyObject(materials.furs)
            || !isEmptyObject(materials.hooks) || !isEmptyObject(materials.synthetics)
            || !isEmptyObject(materials.threads) || !isEmptyObject(materials.tinsels)
            || !isEmptyObject(materials.wires) || !isEmptyObject(materials.yarns);
    }

    function isFlyInstructionsValid(prop: object): boolean {
        return !isEmptyObject(prop);
    }
    function isEmptyObject(prop: object): boolean {
        return prop === null || prop === undefined || !Object.keys(prop)
            || !(Object.keys(prop).length > 0)
    }

}

interface Materials {
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

interface Attributes {
    difficulty: string,
    style: string,
    target: string,
    type: string
}
