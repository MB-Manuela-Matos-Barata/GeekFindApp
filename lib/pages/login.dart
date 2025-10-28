import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geek_find_projeto/pages/registo.dart';
import 'package:geek_find_projeto/pages/home.dart'; // ADICIONE ESTE IMPORT

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print('LoginPage inicializada');

    // ✅ CORREÇÃO: Apenas inicialize o estado, não limpe os controllers
    _isLoading = false;
    _errorMessage = null;
  }

  Future<void> _login() async {
    // Validação básica
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Por favor, preencha todos os campos.";
      });
      return;
    }

    // Validação de email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      setState(() {
        _errorMessage = "Por favor, insira um email válido.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('=== INICIANDO LOGIN ===');
      print('Email: ${_emailController.text.trim()}');

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('=== LOGIN BEM-SUCEDIDO ===');
      print('Usuário: ${userCredential.user?.email}');
      print('UID: ${userCredential.user?.uid}');

      // ✅ CORREÇÃO: Navegar para a tela principal após login bem-sucedido
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // SUA PÁGINA PRINCIPAL
              (route) => false,
        );
      }

    } on FirebaseAuthException catch (e) {
      print('=== ERRO NO LOGIN: ${e.code} ===');

      String message = 'Erro durante o login. Tente novamente.';
      switch (e.code) {
        case 'user-not-found':
          message = 'Nenhum usuário encontrado para esse email.';
          break;
        case 'wrong-password':
          message = 'Senha incorreta.';
          break;
        case 'invalid-email':
          message = 'O formato do email é inválido.';
          break;
        case 'user-disabled':
          message = 'Esta conta foi desativada.';
          break;
        case 'too-many-requests':
          message = 'Muitas tentativas. Tente novamente mais tarde.';
          break;
        case 'network-request-failed':
          message = 'Erro de conexão. Verifique sua internet.';
          break;
      }

      if (mounted) {
        setState(() {
          _errorMessage = message;
          _isLoading = false;
        });
      }

    } catch (e) {
      print('=== ERRO GERAL NO LOGIN: $e ===');
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro inesperado. Tente novamente.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6c3082);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 4.0,
        shadowColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email, color: primaryColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: primaryColor, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: primaryColor, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // ✅ Lógica para recuperação de senha (placeholder)
                  _showForgotPasswordDialog();
                },
                child: const Text('Esqueceu a Senha?', style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5.0,
              ),
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
                'Entrar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistoPage(),
                  ),
                );
              },
              child: const Text(
                'Não tem uma conta? Registe-se',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Método para mostrar diálogo de recuperação de senha
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar Senha'),
        content: const Text('Funcionalidade de recuperação de senha será implementada em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}