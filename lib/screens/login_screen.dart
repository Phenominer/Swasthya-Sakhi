import 'package:flutter/material.dart';
import 'admin_login.dart'; // Unchanged
import 'worker_login.dart'; // Unchanged
import 'dart:ui'; // Still needed for ImageFilter, oh wait, removing it.
// Actually, 'dart:ui' is no longer needed if BackdropFilter is gone.
// Let's remove it for clean-up.

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),

            // Title - Removed shadows
            const Text(
              "Swasth Sakhi",
              style: TextStyle(
                color: Color(0xFF00C9FF), // Neon blue accent
                fontSize: 36,
                fontWeight: FontWeight.w700,
                // shadows: [] <-- This section has been removed
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              "Empowering healthcare workers",
              style: TextStyle(color: Colors.blueGrey[200], fontSize: 15),
            ),

            const SizedBox(height: 80),

            // Card - Removed BackdropFilter and updated color
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                // BackdropFilter has been removed
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    // Changed to a solid, theme-appropriate color
                    color: const Color(0xFF1E293B),
                    border: Border.all(
                      // Kept the border as it's a clean accent
                      color: const Color(0xFF00C9FF).withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Button calls and instances are unchanged
                      _LoginButton(
                        title: "Worker Login",
                        icon: Icons.badge_rounded,
                        gradient: const [Color(0xFF00AFFF), Color(0xFF00C9FF)],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WorkerLoginScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Button calls and instances are unchanged
                      _LoginButton(
                        title: "Admin Login",
                        icon: Icons.admin_panel_settings_rounded,
                        gradient: const [Color(0xFF1E3A8A), Color(0xFF00AFFF)],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminLoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "© 2024 Swasth Sakhi Project",
                style: TextStyle(color: Colors.blueGrey[700], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _LoginButton class
class _LoginButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _LoginButton({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          // boxShadow: [] <-- This section has been removed
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white60,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
