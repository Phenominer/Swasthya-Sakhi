// lib/services/api_service.dart
import 'package:cloud_functions/cloud_functions.dart';

/// This service handles all communication with your
/// backend (e.g., Cloud Functions).
class ApiService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Calls the 'getAdminData' Cloud Function.
  /// Relies on the user already being authenticated via AuthService.
  Future<Map<String, dynamic>> getAdminData() async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('getAdminData');
      final HttpsCallableResult result = await callable.call();
      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      print("ApiService Error (getAdminData): ${e.message}");
      throw (e.message ?? "Could not get admin data.");
    } catch (e) {
      print("ApiService Error: $e");
      throw ("An unknown error occurred.");
    }
  }

  Future<Map<String, dynamic>> adminLogin(String email, String password) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('adminLogin');
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'email': email,
        'password': password,
      });
      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      print("ApiService Error (adminLogin): ${e.message}");
      throw (e.message ?? "Login failed.");
    }
  }

  /// Calls the 'workerLogin' Cloud Function.
  Future<Map<String, dynamic>> loginWorker(
    String workerId,
    String phone,
  ) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'workerLogin',
      ); // CHANGED from loginWorkerByPhoneAndId
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'workerId': workerId,
        'phone': phone,
      });
      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      print("ApiService Error (loginWorker): ${e.message}");
      throw (e.message ?? "Login failed.");
    }
  }

  /// Calls the 'loginWorkerByPhoneAndId' Cloud Function.

  /// Placeholder: A function to add a patient to the database.
  Future<void> addPatientToDB(Map<String, dynamic> patientData) async {
    // In a real app, you'd have a Cloud Function for this:
    // final HttpsCallable callable = _functions.httpsCallable('addPatient');
    // await callable.call(patientData);

    // For now, we just simulate a successful backend call.
    await Future.delayed(const Duration(milliseconds: 500));
    print("Patient data sent to backend (simulated).");
  }

  /// Placeholder: A function to add a worker to the database.
  Future<void> addWorkerToDB(Map<String, dynamic> workerData) async {
    // final HttpsCallable callable = _functions.httpsCallable('addWorker');
    // await callable.call(workerData);
    await Future.delayed(const Duration(milliseconds: 500));
    print("Worker data sent to backend (simulated).");
  }

  /// Placeholder: A function to update inventory in the database.
  Future<void> updateInventoryInDB(String itemId, int newStock) async {
    // final HttpsCallable callable = _functions.httpsCallable('updateInventory');
    // await callable.call({'itemId': itemId, 'newStock': newStock});
    await Future.delayed(const Duration(milliseconds: 300));
    print("Inventory updated in backend (simulated).");
  }
}
