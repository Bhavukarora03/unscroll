const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();


const toExactMinute = 1000 * 60 * 60 * 24;
// eslint-disable-next-line require-jsdoc
function updateDoc(id) {
  admin.firestore()
      .collection("users")
      .doc(id)
      .update({thirtyMinDone: false})
      .then(() => {
        console.log("Document ID: "+id+" successfully updated!");
      })
      .catch((error) => {
        console.error("Error updating document: ", error);
      });
}

exports.updateField = functions.firestore
    .document("/users/{id}")
    .onUpdate((snapshot, context) => {
      console.log("updated success");
      const id = context.params.id;
      setTimeout(() => updateDoc(id), toExactMinute);
      return id;
    });
