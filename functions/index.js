const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();


const sgMail = require("@sendgrid/mail");
// eslint-disable-next-line max-len
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

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


// eslint-disable-next-line max-len
exports.sendEmail = functions.firestore.document("/users/{id}").onCreate((users) => {
  const userId = users.id;
  const db = admin.firestore();
  return db.collection("users").doc(userId).get().then((doc) => {
    const userId = doc.data();

    const msg = {
      to: userId.email,
      from: "bhavuk.arora03@gmail.com",
      template_Id: "d-1cb3a6be2027491098d42629ca402eef",
      dynamic_template_data: {
        subject: "Welcome to the team!",
        name: userId.name,
      },
    };
    return sgMail.send(msg);
  }).then(() => {
    console.log("Email sent");
  }
  ).catch((error) => {
    console.error(error);
  }
  );
});

