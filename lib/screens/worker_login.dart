import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/appstate.dart'; // <-- Import AppState

class WorkerLoginScreen extends StatefulWidget {
  const WorkerLoginScreen({super.key});

  @override
  State<WorkerLoginScreen> createState() => _WorkerLoginScreenState();
}

class _WorkerLoginScreenState extends State<WorkerLoginScreen> {
  // Pre-fill for easy hackathon demo of Heena's account
  final TextEditingController workerIdController = TextEditingController(
    text: "heena@gmail.com",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "Heena1234",
  );

  bool _isLoading = false; // Local loading state for button

  /// Handles the login logic
  void _handleLogin() async {
    if (_isLoading) return;

    final app = context.read<AppState>();

    setState(() => _isLoading = true);

    final success = await app.loginAsWorker(
      workerIdController.text.trim(),
      phoneController.text.trim(),
    );

    if (context.mounted) {
      setState(() => _isLoading = false);

      if (success) {
        // Pop back to the RootRouter, which will now show the HomeScreen
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        // Show the error from AppState
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(app.loginError ?? "An unknown error occurred."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Worker Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Login using your credentials.",
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 40),

              // Worker ID
              _InputField(
                controller: workerIdController,
                label: "Worker ID or Email", // Updated label
                icon: Icons.badge_rounded,
              ),
              const SizedBox(height: 20),

              // Phone number
              _InputField(
                controller: phoneController,
                label: "Phone Number or Password", // Updated label
                icon: Icons.phone_android_rounded,
                obscure: true, // Hide password
              ),
              const SizedBox(height: 35),

              // CONTINUE button
              InkWell(
                onTap: _handleLogin, // <-- CONNECTED
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1E3A8A).withOpacity(0.9),
                        const Color(0xFF3B82F6).withOpacity(0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Or use worker login from your organization",
                  style: TextStyle(color: Colors.blue.shade300, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Pre-fill for Sunita's demo
                  workerIdController.text = "w1_sunita";
                  phoneController.text = "9988776655";
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.apartment_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          "Demo: Login as Sunita",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------- REUSABLE INPUT FIELD ----------------------
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        cursorColor: Colors.blueAccent,
        style: const TextStyle(color: Colors.white),
        keyboardType: label.contains("Phone")
            ? TextInputType.phone
            : TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
