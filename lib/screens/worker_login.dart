import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swasth_sakhi/state/appstate.dart';

class WorkerLoginScreen extends StatefulWidget {
  const WorkerLoginScreen({super.key});

  @override
  State<WorkerLoginScreen> createState() => _WorkerLoginScreenState();
}

class _WorkerLoginScreenState extends State<WorkerLoginScreen> {
  final TextEditingController workerIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // 'loading' is now controlled by AppState, so we remove it here.
  // bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Watch AppState for loading and error messages
    final app = context.watch<AppState>();

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
              // ... (Header text is the same)
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
                "Login using your Worker ID or Phone Number.",
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 40),

              // Worker ID
              _InputField(
                controller: workerIdController,
                label: "Worker ID",
                icon: Icons.badge_rounded,
              ),
              const SizedBox(height: 20),

              // Phone number
              _InputField(
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone_android_rounded,
              ),
              const SizedBox(height: 35),

              // --- UPDATED CONTINUE BUTTON ---
              InkWell(
                onTap: app.isLoading
                    ? null
                    : () {
                        // All logic is moved to AppState!
                        context.read<AppState>().loginAsWorker(
                          workerIdController.text.trim(),
                          phoneController.text.trim(),
                        );
                      },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    // ... (styles are the same)
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
                    // Show a spinner or text
                    child: app.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
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

              // --- ERROR MESSAGE ---
              if (app.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(
                      app.errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),
              // ... (rest of the file is the same)
              Center(
                child: Text(
                  "Or use worker login from your organization",
                  style: TextStyle(color: Colors.blue.shade300, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {},
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
                          "Select Organization",
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

// ... (_InputField widget is unchanged)
// ---------------------- REUSABLE INPUT FIELD ----------------------
class _InputField extends StatelessWidget {
  // ... (no changes)
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
