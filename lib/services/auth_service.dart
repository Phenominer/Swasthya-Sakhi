// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

/// This service handles Firebase Authentication only.
/// (e.g., email/password, phone auth, etc.)
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gets the current authenticated user, if any.
  User? get currentUser => _auth.currentUser;

  /// Signs in an admin using email and password.
  Future<User?> signInAdmin(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("AuthService Error (signInAdmin): ${e.message}");
      throw (e.message ?? "An unknown auth error occurred.");
    } catch (e) {
      print("AuthService Error: $e");
      throw ("An unknown error occurred.");
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // In a real app, you would add worker phone auth here
  // e.g., verifyPhoneNumber()
}
