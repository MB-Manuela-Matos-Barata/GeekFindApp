import 'package:flutter/material.dart';
import 'package:geek_find_projeto/pages/menu_lateral.dart';


class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Configurações",
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

      // Para o IconButton acima funcionar, precisa ter um Drawer:
      drawer: const MenuLateral(),

      //Conteudo do Home
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Conteudo Principal'),
        ),
      ),
    );
  }
}