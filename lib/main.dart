import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:geek_find_projeto/pages/home.dart';
import 'package:geek_find_projeto/pages/login.dart';
import 'package:geek_find_projeto/pages/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('=== INICIANDO APP ===');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Verifique o estado inicial
  final currentUser = FirebaseAuth.instance.currentUser;
  print('=== APP INICIADO ===');
  print('Usuário atual: ${currentUser?.email}');
  print('UID: ${currentUser?.uid}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'GeekFind',
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF6c3082),
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF0f0f23),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF6c3082),
                foregroundColor: Colors.white,
              ),
            ),
            themeMode: themeManager.themeMode,
            home: const AuthCheck(),
          );
        },
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Apenas para a tela inicial do app
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final User? user = snapshot.data;

        if (user == null) {
          return const LoginPage(); // Tela inicial se não logado
        } else {
          return const HomePage(); // Tela inicial se já logado
        }
      },
    );
  }
}