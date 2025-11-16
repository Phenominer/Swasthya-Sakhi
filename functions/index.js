// Import all your function handlers
const handlers = require("files/handlers");

// Export them to Firebase
exports.adminLogin = handlers.adminLogin;
exports.workerLogin = handlers.workerLogin;