// lib/state/appstate.dart
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  /* ---------------- USER / SESSION ---------------- */
  String userId = "";
  String userName = "Guest Worker";
  String role = "worker";
  bool isLoggedIn = false;

  /* ---------------- UI ---------------- */
  bool isLoading = false;
  String? loginError;

  /* ---------------- ALERTS ---------------- */
  List<Map<String, dynamic>> alerts = [];
  List<Map<String, dynamic>> get unreadAlerts =>
      alerts.where((a) => a['read'] == false).toList();

  /* ---------------- GAMIFICATION ---------------- */
  int points = 0;
  int badges = 0;
  int streak = 0;
  int recordsUpdated = 0;
  List<Map<String, dynamic>> leaderboard = [];
  List<Map<String, dynamic>> achievements = [];

  /* ---------------- WORKER DATA ---------------- */
  List<Map<String, dynamic>> myPatients = [];
  List<Map<String, dynamic>> myInventory = [];

  /* ---------------- "DATABASE" (ADMIN DATA) ---------------- */
  List<Map<String, dynamic>> allWorkers = [];
  List<Map<String, dynamic>> allPatients = [];
  List<Map<String, dynamic>> globalInventory = [];

  /* ---------------- METRICS ---------------- */
  int totalWorkers = 0;
  int totalPatients = 0;

  AppState() {
    // Load the "database" when the app starts
    _loadGlobalData();
  }

  /// This is our local "database" of all users and global items.
  void _loadGlobalData() {
    allWorkers = [
      {
        "id": "w1_sunita",
        "name": "Sunita Devi",
        "role": "worker",
        "phone": "9988776655",
        "area": "Gopalpur",
        "organisation": "PHC Gopalpur",
        "patients": 142,
        "points": 1250,
        "streak": 12,
        "active": true,
      },
      {
        "id": "w2_asha",
        "name": "Asha Sharma",
        "role": "worker",
        "phone": "9911223344",
        "area": "Rampur",
        "organisation": "PHC Rampur",
        "patients": 110,
        "points": 980,
        "streak": 5,
        "active": false,
      },
      // This is the worker from your request!
      {
        "id": "w3_heena",
        "name": "Heena",
        "role": "worker",
        "phone": "9876543210", // Using a sample phone
        "area": "Chandigarh",
        "organisation": "PHC Chandigarh",
        "patients": 75,
        "points": 720,
        "streak": 3,
        "active": true,
      },
    ];

    allPatients = [
      {
        "id": "ap1",
        "name": "Ram Devi (Global)",
        "age": 51,
        "gender": "Female",
        "phone": "9001100220",
        "status": "stable",
        "address": "Gopalpur Main Road",
        "village": "Gopalpur",
        "history": ["Diabetes"],
        "lastVisit": "2025-01-05",
        "nextVisit": "2025-02-09",
      },
      {
        "id": "ap2",
        "name": "Kusum Devi (Global)",
        "age": 38,
        "gender": "Male",
        "phone": "9001122334",
        "status": "critical",
        "address": "Ward 7, Rampur",
        "village": "Rampur",
        "history": ["High Fever"],
        "lastVisit": "2025-01-11",
        "nextVisit": "2025-02-12",
      },
    ];

    globalInventory = [
      {
        "id": "m_parac_g",
        "name": "Paracetamol (Global)",
        "stock": 400,
        "expiry": "2025-07-18",
      },
      {
        "id": "m_ors_g",
        "name": "ORS Packets (Global)",
        "stock": 25, // Set to low stock for demo
        "expiry": "2025-03-22",
      },
    ];

    leaderboard = [
      {"name": "Sunita Devi", "points": 1250},
      {"name": "Asha Sharma", "points": 980},
      {"name": "Heena", "points": 720},
    ];

    _buildDerivedMetrics();
    // No notifyListeners() needed here, it's the constructor.
  }

  /// This function loads the specific data for the logged-in worker.
  void _loadWorkerData(Map<String, dynamic> worker) {
    // Populate session info
    role = "worker";
    userName = worker['name'];
    userId = worker['id'];
    points = worker['points'];
    badges = 3; // hardcoded for demo
    streak = worker['streak'];
    recordsUpdated = 12; // hardcoded for demo

    // Simulate fetching this worker's specific data
    // For the hackathon, we just load hardcoded data.
    myPatients = [
      {
        "id": "p_ram",
        "name": "Ram Devi (My Patient)",
        "age": 34,
        "gender": "Female",
        "phone": "9998887771",
        "status": "critical",
        "address": "House 12, Gopalpur",
        "village": "Gopalpur",
        "history": ["Fever", "Low BP"],
        "lastVisit": "2025-01-09",
        "nextVisit": "2025-02-18",
      },
    ];

    myInventory = [
      {
        "id": "m_ors_h",
        "name": "ORS Packets (My Stock)",
        "stock": 25,
        "expiry": "2025-03-22",
      },
    ];

    achievements = [
      {
        "id": "ach1",
        "title": "First Patient Registered",
        "icon": Icons.person_add_alt_1,
        "earned": true,
      },
      {
        "id": "ach3",
        "title": "Inventory Updated",
        "icon": Icons.inventory_2_outlined,
        "earned": true,
      },
      {
        "id": "ach2",
        "title": "10 Patients Registered",
        "icon": Icons.people,
        "earned": false,
      },
    ];

    alerts = [
      {
        "id": "a1",
        "msg": "Low Stock: ORS below 30",
        "type": "warning",
        "read": false,
        "createdAt": DateTime.now(),
      },
    ];
  }

  /// This function loads the specific data for the logged-in admin.
  void _loadAdminData() {
    role = "admin";
    userName = "Admin";
    userId = "admin_01";
    alerts = [
      {
        "id": "a_g1",
        "msg": "2 workers have pending updates",
        "type": "info",
        "read": false,
        "createdAt": DateTime.now(),
      },
      {
        "id": "a_g2",
        "msg": "Critical stock level for ORS Packets",
        "type": "critical",
        "read": true,
        "createdAt": DateTime.now(),
      },
    ];
    // Admin data (allWorkers, allPatients, etc.) is already loaded by _loadGlobalData()
  }

  void _startLoading() {
    isLoading = true;
    loginError = null;
    notifyListeners();
  }

  void _stopLoading({String? error}) {
    isLoading = false;
    loginError = error;
    notifyListeners();
  }

  /* =============================================================
   LOGIN / LOGOUT FUNCTIONS
  ============================================================= */

  /// Attempts to log in as an Admin.
  Future<bool> loginAsAdmin(String email, String password) async {
    _startLoading();
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network

    if (email == "admin@admin.com" && password == "Akshat1234") {
      _loadAdminData(); // Load admin-specific data
      isLoggedIn = true;
      _stopLoading();
      return true;
    } else {
      _stopLoading(error: "Invalid admin credentials.");
      return false;
    }
  }

  /// Attempts to log in as a Worker.
  Future<bool> loginAsWorker(
    String workerIdOrEmail,
    String phoneOrPassword,
  ) async {
    _startLoading();
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network

    Map<String, dynamic>? foundWorker;

    // Check for "heena@gmail.com" / "Heena1234"
    if (workerIdOrEmail == "heena@gmail.com" &&
        phoneOrPassword == "Heena1234") {
      try {
        foundWorker = allWorkers.firstWhere((w) => w['name'] == 'Heena');
      } catch (e) {
        _stopLoading(error: "Heena's test account not found in DB.");
        return false;
      }
    } else {
      // Check for regular Worker ID / Phone
      try {
        foundWorker = allWorkers.firstWhere(
          (w) => w['id'] == workerIdOrEmail && w['phone'] == phoneOrPassword,
        );
      } catch (e) {
        // No match found, do nothing
      }
    }

    if (foundWorker != null) {
      _loadWorkerData(foundWorker); // Load this worker's specific data
      isLoggedIn = true;
      _stopLoading();
      return true;
    } else {
      _stopLoading(error: "Invalid Worker ID or Phone.");
      return false;
    }
  }

  /// Logs out the current user and clears session state.
  Future<void> logout() async {
    _startLoading();
    await Future.delayed(const Duration(milliseconds: 200));

    // Reset session state
    isLoggedIn = false;
    userId = "";
    userName = "Guest Worker";
    role = "worker";
    loginError = null;

    // Clear user-specific data
    alerts = [];
    points = 0;
    badges = 0;
    streak = 0;
    recordsUpdated = 0;
    // We keep the leaderboard, as it's global
    achievements = [];
    myPatients = [];
    myInventory = [];

    // We keep allWorkers, allPatients, etc. loaded as they are the "global" DB.

    _stopLoading();
  }

  // --- The rest of your functions (addPatient, addWorker, etc.) ---
  // These will now work by modifying the local lists.

  void _buildDerivedMetrics() {
    totalWorkers = allWorkers.length;
    totalPatients = allPatients.length; // Simplified for local demo
  }

  void addPatient(Map<String, dynamic> patient, {bool global = false}) {
    final p = Map<String, dynamic>.from(patient);
    p['id'] = p['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();

    if (global && role == 'admin') {
      allPatients.insert(0, p);
    } else {
      myPatients.insert(0, p);
    }
    _buildDerivedMetrics();
    notifyListeners();
  }

  void addWorker(Map<String, dynamic> worker) {
    final w = Map<String, dynamic>.from(worker);
    // Add default stats for the new worker
    w['id'] = w['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    w['patients'] = w['patients'] ?? 0;
    w['points'] = w['points'] ?? 0;
    w['streak'] = w['streak'] ?? 0;
    w['active'] = w['active'] ?? true;

    allWorkers.insert(0, w);
    totalWorkers = allWorkers.length;
    notifyListeners();
  }

  void addInventoryItem(Map<String, dynamic> item, {bool global = false}) {
    final it = Map<String, dynamic>.from(item);
    it['id'] = it['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();

    if (global && role == 'admin') {
      globalInventory.insert(0, it);
    } else {
      myInventory.insert(0, it);
    }
    notifyListeners();
  }

  void updateInventoryItem(
    String id,
    Map<String, dynamic> item, {
    bool global = false,
  }) {
    List<Map<String, dynamic>> list = global ? globalInventory : myInventory;
    final idx = list.indexWhere((m) => m['id'] == id);
    if (idx >= 0) {
      list[idx] = {...list[idx], ...item};
      notifyListeners();
    }
  }

  void addAlert(String msg, {String type = "info"}) {
    final a = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "msg": msg,
      "type": type,
      "read": false,
      "createdAt": DateTime.now(),
    };
    alerts.insert(0, a);
    notifyListeners();
  }

  void markAlertRead(String id, {bool read = true}) {
    final idx = alerts.indexWhere((a) => a['id'] == id);
    if (idx >= 0) {
      alerts[idx]['read'] = read;
      notifyListeners();
    }
  }

  void markAllAlertsRead() {
    for (var a in alerts) {
      a['read'] = true;
    }
    notifyListeners();
  }

  Map<String, dynamic>? findPatientById(String id) {
    final inMy = myPatients.firstWhere((p) => p['id'] == id, orElse: () => {});
    if (inMy.isNotEmpty) return inMy;
    final inAll = allPatients.firstWhere(
      (p) => p['id'] == id,
      orElse: () => {},
    );
    if (inAll.isNotEmpty) return inAll;
    return null;
  }

  Map<String, dynamic>? findWorkerById(String id) {
    try {
      final w = allWorkers.firstWhere((w) {
        final wid = w['id']?.toString() ?? w['workerId']?.toString() ?? '';
        return wid == id;
      }, orElse: () => {});
      if (w.isNotEmpty) return w;
    } catch (_) {}
    return null;
  }
}
