import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geek_find_projeto/pages/theme_manager.dart';
import 'package:geek_find_projeto/pages/login.dart';
import 'package:geek_find_projeto/pages/config.dart';
import 'package:geek_find_projeto/pages/home.dart';
import 'package:geek_find_projeto/pages/testebd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geek_find_projeto/pages/perfil.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isLoggedIn = user != null;
    final themeManager = Provider.of<ThemeManager>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Usuário'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 24, color: Color(0xFF6c3082)),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF6c3082),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: (){
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/home') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            },
          ),

          if(isLoggedIn)
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfigPage()),
              );
            },
          ),

          // NOVO: Toggle de Tema Claro/Escuro
          ListTile(
            leading: Icon(themeManager.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: Text(themeManager.isDarkMode ? 'Modo Escuro' : 'Modo Claro'),
            trailing: Switch(
              value: !themeManager.isDarkMode, // Invertido porque quando switch é true = claro
              onChanged: (value) {
                themeManager.setTheme(!value); // value=true (claro) → isDark=false
              },
              activeColor: const Color(0xFF6c3082),
            ),
            onTap: () {
              themeManager.toggleTheme(!themeManager.isDarkMode);
            },
          ),

          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text('Teste Base de Dados'),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TesteDbPage()),
              );
            },
          ),

          const Divider(),

          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Sair'),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              },
            )
        ],
      ),
    );
  }
}