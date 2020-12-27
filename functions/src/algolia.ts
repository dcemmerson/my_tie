import * as functions from "firebase-functions";
// import * as admin from 'firebase-admin';
import algoliasearch from "algoliasearch";

const ALGOLIA_ID = functions.config().algolia.app_id;
const ALGOLIA_ADMIN_KEY = functions.config().algolia.api_key;
// const ALGOLIA_SEARCH_KEY = functions.config().algolia.search_key;

const ALGOLIA_INDEX_NAME = "flies";
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);
const index = client.initIndex(ALGOLIA_INDEX_NAME);

export { algoliaOnCreate, algoliaOnDelete };

const algoliaOnCreate = functions.firestore
  .document("fly/{flyId}")
  .onCreate((snap, context) => {
    // Get the fly document
    const fly = snap.data();
    fly.objectId = snap.id;
    fly.objectID = snap.id;
    console.log('ALGOLIA_ID');
    console.log(ALGOLIA_ID);
    console.log('ALGOLIA_ADMIN_KEY');
    console.log(ALGOLIA_ADMIN_KEY);

    return index.saveObject(fly);
  });

const algoliaOnDelete = functions.firestore
  .document("fly/{flyId}")
  .onDelete((snap, context) => {
    return index.deleteObject(snap.id);
  });
