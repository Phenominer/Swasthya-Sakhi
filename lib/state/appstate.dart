// lib/state/appstate.dart
import 'package:flutter/material.dart';
import 'package:swasth_sakhi/services/auth_service.dart';
import 'package:swasth_sakhi/services/api_service.dart';

class AppState extends ChangeNotifier {
  // --- Service Dependencies ---
  // These are final and passed in from main.dart
  final AuthService _authService;
  final ApiService _apiService;

  // --- Constructor ---
  AppState(this._authService, this._apiService);

  /* ---------------- USER / SESSION ---------------- */
  String userId = "";
  String userName = "Guest Worker";
  String role = "worker";
  bool isLoggedIn = false;

  /* ---------------- UI ---------------- */
  bool isLoading = false;
  String? errorMessage; // For showing login errors

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

  /* ---------------- ADMIN DATA ---------------- */
  List<Map<String, dynamic>> allWorkers = [];
  List<Map<String, dynamic>> allPatients = [];
  List<Map<String, dynamic>> globalInventory = [];

  /* ---------------- METRICS ---------------- */
  int totalWorkers = 0;
  int totalPatients = 0;

  // --- Private Helper to start loading ---
  void _startLoading() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
  }

  // --- Private Helper to stop loading ---
  void _stopLoading({String? error}) {
    isLoading = false;
    errorMessage = error;
    notifyListeners();
  }

  /* =============================================================
   NEW LOGIN / LOGOUT FUNCTIONS
  =============================================================
  */

  /// Logs in an admin using Email/Password.

  /// Logs in a worker using their custom ID/Phone.
  // ... inside AppState class

  /// Logs in an admin using Email/Password.
  Future<void> loginAsAdmin(String email, String password) async {
    _startLoading();
    try {
      // 1. Call the new function. No AuthService needed.
      final payload = await _apiService.adminLogin(email, password); // CHANGED

      // 2. Load data into state
      _loadDataFromPayload(payload);
      _stopLoading();
    } catch (e) {
      _stopLoading(error: e.toString());
    }
  }

  /// Logs in a worker using their custom ID/Phone.
  Future<void> loginAsWorker(String workerId, String phone) async {
    _startLoading();
    try {
      // 1. Call the new function.
      final payload = await _apiService.loginWorker(workerId, phone); // CHANGED

      // 2. Load data into state
      _loadDataFromPayload(payload);
      _stopLoading();
    } catch (e) {
      _stopLoading(error: e.toString());
    }
  }

  /// Logs out the current user and clears all state.
  Future<void> logout() async {
    _startLoading();
    // No need to call AuthService, just clear state
    // await _authService.signOut(); // REMOVED

    // Clear all local data
    userId = "";
    // ... (rest of the clear state logic is the same)
    _stopLoading();
  }

  // ...
  /// Private function to populate state from a login payload.
  void _loadDataFromPayload(Map<String, dynamic> data) {
    try {
      // Common data
      role = data['role'] ?? 'worker';
      userName = data['userName'] ?? data['name'] ?? 'Worker';
      userId = data['id'] ?? data['uid'] ?? '';
      isLoggedIn = true;

      // --- Alerts ---
      alerts = List<Map<String, dynamic>>.from(data['alerts'] ?? []);

      if (role == 'worker') {
        // --- Worker Data ---
        points = data['points'] ?? 0;
        badges = data['badges'] ?? 0;
        streak = data['streak'] ?? 0;
        recordsUpdated = data['recordsUpdated'] ?? 0;
        myPatients = List<Map<String, dynamic>>.from(data['myPatients'] ?? []);
        myInventory = List<Map<String, dynamic>>.from(
          data['myInventory'] ?? [],
        );
        leaderboard = List<Map<String, dynamic>>.from(
          data['leaderboard'] ?? [],
        );
        achievements = List<Map<String, dynamic>>.from(
          data['achievements'] ?? [],
        );
      } else if (role == 'admin') {
        // --- Admin Data ---
        allWorkers = List<Map<String, dynamic>>.from(data['allWorkers'] ?? []);
        allPatients = List<Map<String, dynamic>>.from(
          data['allPatients'] ?? [],
        );
        globalInventory = List<Map<String, dynamic>>.from(
          data['globalInventory'] ?? [],
        );
      }

      _buildDerivedMetrics();
    } catch (e) {
      print("Error loading from payload: $e");
      throw ("Failed to read data from server.");
    }
  }

  /* =============================================================
   MODIFIED DATA FUNCTIONS (now talk to backend)
  =============================================================
  */

  void _buildDerivedMetrics() {
    totalWorkers = allWorkers.length;
    // This logic might need to be smarter, e.g., sum of worker patients
    totalPatients = myPatients.length + allPatients.length;
  }

  /// Add a patient to the correct list and sync to backend.
  Future<void> addPatient(
    Map<String, dynamic> patient, {
    bool global = false,
  }) async {
    final p = Map<String, dynamic>.from(patient);
    p['id'] = p['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // 1. Send to backend first
      await _apiService.addPatientToDB(p);

      // 2. If successful, update local state
      if (global && role == 'admin') {
        allPatients.insert(0, p);
      } else {
        myPatients.insert(0, p);
      }

      _buildDerivedMetrics();
      notifyListeners();
    } catch (e) {
      print("Error adding patient: $e");
      // Optionally show an error to the user
    }
  }

  /// Add a worker and sync to backend.
  Future<void> addWorker(Map<String, dynamic> worker) async {
    final w = Map<String, dynamic>.from(worker);
    w['id'] = w['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // 1. Send to backend first
      await _apiService.addWorkerToDB(w);

      // 2. If successful, update local state (admin only)
      if (role == 'admin') {
        allWorkers.insert(0, w);
        totalWorkers = allWorkers.length;
        notifyListeners();
      }
    } catch (e) {
      print("Error adding worker: $e");
    }
  }

  /// Update an inventory item and sync to backend.
  Future<void> updateInventoryItem(
    String id,
    Map<String, dynamic> item, {
    bool global = false,
  }) async {
    List<Map<String, dynamic>> list = global ? globalInventory : myInventory;
    final idx = list.indexWhere((m) => m['id'] == id);

    if (idx >= 0) {
      // Optimistically update the UI
      final oldItem = Map<String, dynamic>.from(list[idx]);
      final newItem = {...oldItem, ...item};
      list[idx] = newItem;
      notifyListeners();

      try {
        // 1. Send update to backend
        await _apiService.updateInventoryInDB(id, newItem['stock'] ?? 0);
      } catch (e) {
        print("Error updating inventory: $e");
        // 2. If failed, roll back the change
        list[idx] = oldItem;
        notifyListeners();
        // Show error to user
      }
    }
  }

  /* ---------------- ALERT HELPERS (No backend call needed yet) ---------------- */
  void addAlert(String msg, {String type = "info"}) {
    // ... (no changes)
  }
  void markAlertRead(String id, {bool read = true}) {
    // ... (no changes)
  }
  void markAllAlertsRead() {
    // ... (no changes)
  }

  /* ---------------- FINDER HELPERS (No changes needed) ---------------- */
  Map<String, dynamic>? findPatientById(String id) {
    // ... (no changes)
  }
  Map<String, dynamic>? findWorkerById(String id) {
    // ... (no changes)
  }

  /* ---------------- INVENTORY HELPERS (No backend call) ---------------- */
  void addInventoryItem(Map<String, dynamic> item, {bool global = false}) {
    // This just adds to the local list. We should add a backend call here.
    // For now, it matches your existing code.
    final it = Map<String, dynamic>.from(item);
    it['id'] = it['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();

    if (global && role == 'admin') {
      globalInventory.insert(0, it);
    } else {
      myInventory.insert(0, it);
    }
    notifyListeners();
  }
}
