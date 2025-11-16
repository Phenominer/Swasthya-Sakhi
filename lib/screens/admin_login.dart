import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/appstate.dart'; // <-- Import AppState

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  // Pre-fill controllers for easy hackathon demo
  final TextEditingController emailController = TextEditingController(
    text: "admin@admin.com",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "Akshat1234",
  );
  bool obscure = true;

  // This local loading state is useful for the button spinner
  bool _isLoading = false;

  /// Handles the login logic
  void _handleLogin() async {
    if (_isLoading) return;

    // Use context.read inside a function, it doesn't listen for changes
    final app = context.read<AppState>();

    setState(() => _isLoading = true);

    final success = await app.loginAsAdmin(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    // We check 'mounted' in case the widget is removed
    if (context.mounted) {
      setState(() => _isLoading = false);

      if (success) {
        // Pop back to the RootRouter, which will now show the AdminHome
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
                  onPressed: () => setState(() => obscure = !obscure),
                ),
              ),
              const SizedBox(height: 35),

              // Login Button
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

              const SizedBox(height: 18),
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

// ---------------------- REUSABLE INPUT FIELD ----------------------
class _InputField extends StatelessWidget {
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
