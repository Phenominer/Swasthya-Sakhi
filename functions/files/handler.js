const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { 
  checkAdminCredentials, 
  checkWorkerIdAndPhone, 
  throwAuthError 
} = require("./auth");

admin.initializeApp();
const db = admin.firestore();

/**
 * ===================================================================
 * ADMIN: Login with Email/Pass and Get Data
 * ===================================================================
 * This function is INSECURE but fast for a hackathon.
 * It takes email/pass directly from the Flutter app.
 */
const adminLogin = functions.https.onCall(async (data, context) => {
  const { email, password } = data;

  // 1. Check credentials
  if (!checkAdminCredentials(email, password)) {
    throwAuthError();
  }

  // 2. Credentials are good, fetch data
  try {
    const [workersSnap, patientsSnap, inventorySnap, alertsSnap] = await Promise.all([
      db.collection("workers").get(),
      db.collection("patients").get(),
      db.collection("globalInventory").get(),
      db.collection("alerts").get(),
    ]);

    const allWorkers = workersSnap.docs.map(doc => doc.data());
    const allPatients = patientsSnap.docs.map(doc => doc.data());
    const globalInventory = inventorySnap.docs.map(doc => doc.data());
    const alerts = alertsSnap.docs.map(doc => doc.data());

    // 3. Return the payload
    return {
      role: "admin",
      userName: "Admin",
      allWorkers,
      allPatients,
      globalInventory,
      alerts,
    };
  } catch (error) {
    console.error("Error fetching admin data:", error);
    throw new functions.https.HttpsError("internal", "Could not fetch admin data.");
  }
});

/**
 * ===================================================================
 * WORKER: Login with ID/Phone and Get Data
 * ===================================================================
 * This matches your Flutter app's login form.
 */
const workerLogin = functions.https.onCall(async (data, context) => {
  const { workerId, phone } = data;

  // 1. Check credentials
  if (!checkWorkerIdAndPhone(workerId, phone)) {
    throwAuthError();
  }
  
  // 2. Credentials are good, fetch data for this worker
  //    (This assumes your worker doc ID is 'HEENA01' like the workerId)
  const workerRef = db.collection("workers").doc(workerId);
  
  try {
    const [
      workerDoc,
      patientsSnap,
      inventorySnap,
      achievementsSnap,
    ] = await Promise.all([
      workerRef.get(),
      workerRef.collection("myPatients").get(),
      workerRef.collection("myInventory").get(),
      workerRef.collection("achievements").get(),
      // You'd also fetch global alerts, leaderboard, etc.
    ]);
    
    if (!workerDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Worker profile not found in DB.");
    }

    const myPatients = patientsSnap.docs.map(doc => doc.data());
    const myInventory = inventorySnap.docs.map(doc => doc.data());
    const achievements = achievementsSnap.docs.map(doc => doc.data());

    // 3. Return the payload
    return {
      ...workerDoc.data(), // Includes name, points, streak, etc.
      role: "worker",
      myPatients,
      myInventory,
      achievements,
      alerts: [], // Add alerts
      leaderboard: [], // Add leaderboard
    };
  } catch (error) {
    console.error("Error fetching worker data:", error);
    throw new functions.https.HttpsError("internal", "Could not fetch worker data.");
  }
});


module.exports = {
  adminLogin,
  workerLogin,
};