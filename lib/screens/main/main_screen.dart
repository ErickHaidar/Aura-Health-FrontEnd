import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import '../../core/config/api_config.dart';
import '../../core/theme/app_theme.dart';
import 'home_screen.dart';
import '../education/education_screen.dart';
import '../community/community_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late socket_io.Socket socket;

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  void _initSocket() {
    // Menghubungkan socket.io ke backend menggunakan namespace/baseUrl
    final uri = ApiConfig.baseUrl.replaceAll('/api', '');
    socket = socket_io.io(
      uri,
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();

    socket.on('comment_created', (data) {
      if (mounted && data != null && data['comment'] != null) {
        final author = data['comment']['authorName'] ?? 'Seseorang';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$author mengomentari sebuah post!'),
            backgroundColor: AppTheme.primaryColor,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onNavigateTab: (index) => setState(() => _currentIndex = index),
      ),
      const EducationScreen(),
      const CommunityScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: Theme.of(context).cardColor,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Edukasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Komunitas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
