import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:swasth_sakhi/screens/admin_home.dart';
import 'package:swasth_sakhi/screens/home_screen.dart';
import 'package:swasth_sakhi/screens/login_screen.dart'; // Import the correct login screen

import 'state/appstate.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => AppState(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swasth Sakhi',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 1, 16, 37),
        primaryColor: const Color.fromARGB(255, 26, 64, 169),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 3, 75, 55),
          secondary: Color.fromARGB(255, 246, 59, 59),
          surface: Color(0xFF111827),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
      home: const RootRouter(),
    );
  }
}

/* ----------------------------------------------------
   ROOT ROUTER: decides which home screen to show
   based on AppState role + login state
-----------------------------------------------------*/

class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    // Show a loading spinner while logging in or out
    if (app.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Not logged in -> Login selection screen
    if (!app.isLoggedIn) {
      // Use the LoginScreen with the two buttons
      return const LoginScreen();
    }

    // Logged in -> send to worker or admin dashboard
    if (app.role == "worker") {
      return const HomeScreen();
    } else {
      return const AdminHomeScreen();
    }
  }
}
