import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geek_find_projeto/pages/home.dart';
import 'package:geek_find_projeto/pages/login.dart';

class RegistoPage extends StatefulWidget {
  const RegistoPage({super.key});

  @override
  State<RegistoPage> createState() => _RegistoPageState();
}

class _RegistoPageState extends State<RegistoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  static const Color primaryColor = Color(0xFF6c3082);

  @override
  void initState() {
    super.initState();
    print('RegistoPage inicializada');
  }

  bool _validateFields() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Por favor, preencha todos os campos.";
      });
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _errorMessage = "Por favor, insira um email válido.";
      });
      return false;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = "A senha deve ter pelo menos 6 caracteres.";
      });
      return false;
    }

    return true;
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registro realizado com sucesso!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_validateFields()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('=== INICIANDO REGISTRO ===');

      // 1. Criação do usuário
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('=== USUÁRIO CRIADO: ${userCredential.user?.uid} ===');

      // 2. Adiciona o nome
      await userCredential.user?.updateDisplayName(_nameController.text.trim());
      await userCredential.user?.reload();

      print('=== NOME ATUALIZADO ===');
      print('=== USUÁRIO FINAL: ${FirebaseAuth.instance.currentUser?.displayName} ===');

      setState(() {
        _isLoading = false;
      });

      // ✅✅✅ CORREÇÃO PRINCIPAL: NAVEGAÇÃO APÓS SUCESSO
      if (mounted) {
        _showSuccessMessage();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      }

      print('=== REGISTRO CONCLUÍDO - REDIRECIONANDO PARA HOME ===');

    } on FirebaseAuthException catch (e) {
      print('=== ERRO NO REGISTRO: ${e.code} ===');

      String message = 'Ocorreu um erro durante o registo.';
      if (e.code == 'weak-password') {
        message = 'A senha deve ter pelo menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Este email já está em uso.';
      } else if (e.code == 'invalid-email') {
        message = 'O formato do email é inválido.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Operação não permitida.';
      } else if (e.code == 'network-request-failed') {
        message = 'Erro de conexão. Verifique sua internet.';
      }

      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });
    } catch (e) {
      print('=== ERRO GERAL: $e ===');
      setState(() {
        _errorMessage = 'Erro inesperado: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registo",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 2.0,
        shadowColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Crie sua conta',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Campo Nome
            TextFormField(
              controller: _nameController,
              focusNode: _nameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailFocus);
              },
              decoration: InputDecoration(
                labelText: 'Nome Completo',
                prefixIcon: const Icon(Icons.person, color: primaryColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: primaryColor, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo Email
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocus);
              },
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

            // Campo Senha
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                _handleRegister();
              },
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: primaryColor,
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

            // Mensagem de erro
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),

            // Botão de Registro
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
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
                'Registar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Link para Login
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text(
                'Já tem uma conta? Faça Login',
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}