import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geek_find_projeto/pages/menu_lateral.dart';

class TesteDbPage extends StatelessWidget {
  const TesteDbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Base De Dados",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: const Color(0xFF6c3082),
        elevation: 2.0,
        shadowColor: Colors.black,
        centerTitle: true,

        leading: Builder( // O Builder cria um novo contexto
            builder: (context) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  //color: Colors.purple, // Cor do fundo do Container
                    borderRadius: BorderRadius.circular(5)
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    // AGORA FUNCIONA: O 'context' do Builder inclui o Scaffold acima.
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            }
        ),
      ),

      drawer: const MenuLateral(),

      body: Center(
        // CONTEÚDO DE TESTE: Verifica a conexão com o Firestore
        child: StreamBuilder<DocumentSnapshot>(
          // Tenta ler o documento: Collection 'teste', Documento 'status'
          stream: FirebaseFirestore.instance.collection('teste').doc('status').snapshots(),

          builder: (context, snapshot) {

            // 1. Carregando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Color(0xFF6c3082));
            }

            // 2. Erro (Falha na conexão, geralmente regras de segurança)
            if (snapshot.hasError) {
              return Text(
                '❌ ERRO: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              );
            }

            // 3. Sucesso! Documento encontrado
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              final mensagem = data?['mensagem'] ?? 'Campo "mensagem" não encontrado.';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 50),
                    const SizedBox(height: 10),
                    const Text(
                      '✅ FIREBASE CONECTADO COM SUCESSO!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6c3082)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mensagem do Banco de Dados:\n"$mensagem"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ],
                ),
              );
            }

            // 4. Documento não encontrado
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Aguardando dados de teste. Por favor, verifique se criou a coleção "teste" e o documento "status" no Console do Firebase.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
            );
          },
        ),
      ),
    );
  }
}
