// This file checks the hardcoded email/password.
// !! HACKATHON-ONLY - Do not use in production !!

const functions = require("firebase-functions");

function checkAdminCredentials(email, password) {
  if (email === "admin@admin.com" && password === "Akshat1234") {
    return true;
  }
  return false;
}

function checkWorkerCredentials(email, password) {
  // NOTE: Your original request used email, but your Flutter app
  // uses Worker ID and Phone. I'll provide both.
  
  // Option 1: Using Email/Password (if you change your Flutter app)
  if (email === "heena@gmail.com" && password === "Heena1234") {
    return true;
  }
  
  // Option 2: Using Worker ID / Phone (Matches your Flutter app)
  // We'll use this one in the handler.
  
  return false;
}

function checkWorkerIdAndPhone(workerId, phone) {
  // You can add more workers here
  if (workerId === "HEENA01" && phone === "9876543210") {
    return true;
  }
  return false;
}


// This is a helper function to throw a standard error
function throwAuthError() {
  throw new functions.https.HttpsError(
    "unauthenticated",
    "Invalid credentials."
  );
}

module.exports = {
  checkAdminCredentials,
  checkWorkerIdAndPhone, // We'll use this
  throwAuthError
};