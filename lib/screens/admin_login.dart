import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swasth_sakhi/state/appstate.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    // Watch AppState for loading and error messages
    final app = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // deep dark navy background
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
                "Admin Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign in with your admin credentials.",
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 40),

              // Email Input
              _InputField(
                controller: emailController,
                label: "Admin Email",
                icon: Icons.email_rounded,
              ),
              const SizedBox(height: 20),

              // Password Input
              _InputField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock_rounded,
                obscure: obscure,
                suffix: IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: Colors.white60,
                  ),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                ),
              ),

              const SizedBox(height: 35),

              // --- UPDATED LOGIN BUTTON ---
              InkWell(
                // Disable button when loading
                onTap: app.isLoading
                    ? null
                    : () {
                        // All logic is moved to AppState!
                        context.read<AppState>().loginAsAdmin(
                          emailController.text.trim(),
                          passwordController.text.trim(),
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
                            "Login",
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

              const SizedBox(height: 18),
              // ... (rest of the file is the same)
              Center(
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.blue.shade300, fontSize: 14),
                ),
              ),
              const SizedBox(height: 35),
              const Center(
                child: Text(
                  "Or continue with",
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
              _SocialButton(
                text: "Continue with external provider",
                icon: Icons.login_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 14),
              _SocialButton(
                text: "Continue with phone number",
                icon: Icons.phone_android_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 14),
              _SocialButton(
                text: "Continue with email",
                icon: Icons.alternate_email_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (_InputField and _SocialButton widgets are unchanged)
// ---------------------- REUSABLE INPUT FIELD ----------------------
class _InputField extends StatelessWidget {
  // ... (no changes)
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Widget? suffix;
  final bool obscure;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.suffix,
    this.obscure = false,
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

// ---------------------- SOCIAL LOGIN BUTTON ----------------------
class _SocialButton extends StatelessWidget {
  // ... (no changes)
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
