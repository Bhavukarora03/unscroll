const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

exports.scheduledFunction = functions.pubsub.schedule("every 5 minutes").onRun((context) =>{
  console.log("This will be run every 5 minutes!");
  return null;
});
