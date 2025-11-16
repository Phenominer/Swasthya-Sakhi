import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // You must generate this file with `flutterfire configure`

// Import Services
import '/services/auth_service.dart';
import '/services/api_service.dart';

// Import Screens (existing)
import 'package:swasth_sakhi/screens/home_screen.dart';
import 'package:swasth_sakhi/screens/admin_home.dart';
import 'package:swasth_sakhi/screens/login_screen.dart';
import 'package:swasth_sakhi/state/appstate.dart';

void main() async {
  // Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // Use MultiProvider to provide services AND AppState
    MultiProvider(
      providers: [
        // --- Provide the services ---
        // These are simple Providers because they don't change state.
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ApiService>(create: (_) => ApiService()),

        // --- Provide AppState ---
        // AppState depends on the services.
        // We use context.read to pass the services into AppState's constructor.
        ChangeNotifierProvider<AppState>(
          create: (context) =>
              AppState(context.read<AuthService>(), context.read<ApiService>()),
        ),
      ],
      child: const MyApp(),
    ),
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
   ROOT ROUTER: (No changes needed)
   This will now work perfectly. When AppState.isLoggedIn
   changes, this widget will rebuild and show the right screen.
-----------------------------------------------------*/
class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer is a bit cleaner here, but Provider.of works fine
    final app = Provider.of<AppState>(context);

    // Show a loading spinner while logging in
    if (app.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Not logged in -> Login selection screen
    if (!app.isLoggedIn) {
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

// LoginTypeSelector is no longer needed, LoginScreen is the entry point
