import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f23),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header do perfil
              _buildProfileHeader(),

              // Estatísticas
              _buildStatsSection(),

              // Preferências
              _buildPreferencesSection(),

              // Configurações
              _buildSettingsSection(),

              const SizedBox(height: 30), // Espaço extra no final
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              color: const Color(0xFF2c3082),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 15),

          // Nome do usuário
          const Text(
            "João Silva",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),

          // Bio
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Gamer apaixonado por RPGs e aventuras épicas",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 15),

          // Botão editar perfil
          Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // Editar perfil
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Color(0xFF6c3082), size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Editar Perfil",
                      style: TextStyle(
                        color: Color(0xFF6c3082),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(number: "24", label: "Jogados"),
            _StatItem(number: "12", label: "Favoritos"),
            _StatItem(number: "156", label: "Horas"),
            _StatItem(number: "8.4", label: "Rating"),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "Preferências",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a2e),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _PreferenceItem(
                  icon: Icons.videogame_asset,
                  title: "Gêneros Favoritos",
                  value: "RPG, Ação, Aventura",
                ),
                const SizedBox(height: 15),
                _PreferenceItem(
                  icon: Icons.computer,
                  title: "Plataformas",
                  value: "PC, PlayStation, Switch",
                ),
                const SizedBox(height: 15),
                _PreferenceItem(
                  icon: Icons.schedule,
                  title: "Tempo de Jogo",
                  value: "2-3 horas por dia",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "Configurações",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a2e),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _SettingsItem(
                  icon: Icons.notifications,
                  title: "Notificações",
                  onTap: () {},
                ),
                const Divider(color: Colors.white12, height: 1),
                _SettingsItem(
                  icon: Icons.privacy_tip,
                  title: "Privacidade",
                  onTap: () {},
                ),
                const Divider(color: Colors.white12, height: 1),
                _SettingsItem(
                  icon: Icons.palette,
                  title: "Tema",
                  onTap: () {},
                ),
                const Divider(color: Colors.white12, height: 1),
                _SettingsItem(
                  icon: Icons.help,
                  title: "Ajuda & Suporte",
                  onTap: () {},
                ),
                const Divider(color: Colors.white12, height: 1),
                _SettingsItem(
                  icon: Icons.logout,
                  title: "Sair",
                  color: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widgets auxiliares
class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _PreferenceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _PreferenceItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF6c3082),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(
                icon,
                color: color ?? const Color(0xFF6c3082),
                size: 22,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color ?? Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}