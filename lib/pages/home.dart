import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geek_find_projeto/pages/menu_lateral.dart';
import 'package:geek_find_projeto/pages/theme_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Método para obter a cor de fundo baseada no tema
  Color _getBackgroundColor(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    return themeManager.isDarkMode ? const Color(0xFF0f0f23) : Colors.white;
  }

  // Método para obter a cor do texto baseada no tema
  Color _getTextColor(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    return themeManager.isDarkMode ? Colors.white : Colors.black;
  }

  // Método para obter a cor secundária do texto
  Color _getSecondaryTextColor(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    return themeManager.isDarkMode ? Colors.white70 : Colors.black54;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: _getBackgroundColor(context),
          appBar: AppBar(
            title: const Text(
              "GeekFind",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            backgroundColor: const Color(0xFF6c3082),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 28),
                onPressed: () {},
              ),
            ],
          ),
          drawer: const MenuLateral(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com boas-vindas (mantém cores fixas)
                _buildWelcomeHeader(),

                // Carrossel de jogos em destaque
                _buildFeaturedSection(context),

                // Seção de jogos populares
                _buildPopularSection(context),

                // Seção de categorias
                _buildCategoriesSection(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6c3082),
            Color(0xFF8a4da3),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Encontre seu próximo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Text(
            "Jogo Favorito!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Descubra jogos incríveis baseados no seu estilo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Em Destaque",
                style: TextStyle(
                  color: _getTextColor(context),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Ver Todos",
                style: TextStyle(
                  color: const Color(0xFF6c3082),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFeaturedGameCard(context, "Cyberpunk 2077", "RPG, Ação", 4.5),
                _buildFeaturedGameCard(context, "The Witcher 3", "RPG, Aventura", 4.8),
                _buildFeaturedGameCard(context, "Elden Ring", "RPG, Souls-like", 4.9),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedGameCard(BuildContext context, String title, String genres, double rating) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF6c3082),
            ),
            child: const Icon(Icons.sports_esports, color: Colors.white, size: 50),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: _getTextColor(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            genres,
            style: TextStyle(
              color: _getSecondaryTextColor(context),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: TextStyle(
                  color: _getTextColor(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Populares",
            style: TextStyle(
              color: _getTextColor(context),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPopularGameCard(context, "God of War", 4.7),
                _buildPopularGameCard(context, "Red Dead 2", 4.8),
                _buildPopularGameCard(context, "Hollow Knight", 4.6),
                _buildPopularGameCard(context, "Hades", 4.9),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularGameCard(BuildContext context, String title, double rating) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            height: 180,
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF30826c),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.sports_esports, color: Colors.white, size: 40),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: _getTextColor(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ThemeManager>(
            builder: (context, themeManager, child) {
              return Text(
                "Categorias",
                style: TextStyle(
                  color: _getTextColor(context),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 2.5,
            children: [
              _buildCategoryCard("RPG", Icons.auto_awesome, const Color(0xFF6c3082)),
              _buildCategoryCard("Ação", Icons.sports_esports, const Color(0xFF30826c)),
              _buildCategoryCard("Aventura", Icons.explore, const Color(0xFF826c30)),
              _buildCategoryCard("Estratégia", Icons.psychology, const Color(0xFF2c3082)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String name, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}