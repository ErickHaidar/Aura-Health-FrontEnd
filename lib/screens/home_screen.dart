import 'package:flutter/material.dart';
import '../theme.dart';
import 'education_screen.dart';
import 'community_screen.dart';
import 'chatbot_screen.dart ';
import 'detection_flow_screen.dart';
import 'profile_screen.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Selamat Pagi!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mari lanjutkan perjalanan sehatmu.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('Layanan Kami', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildServiceCard(Icons.menu_book, 'Edukasi TBC', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EducationScreen(),
                    ),
                  );
                }),
                _buildServiceCard(Icons.search, 'Alur Deteksi', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetectionFlowScreen(),
                    ),
                  );
                }),
                _buildServiceCard(Icons.people, 'Komunitas', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityScreen(),
                    ),
                  );
                }),
                _buildServiceCard(Icons.smart_toy, 'Chatbot AI', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatbotScreen(),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Artikel Terbaru',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ArticleDetailScreen(),
                      ),
                    ),
                    child: _buildArticleCard(
                      'NUTRISI',
                      'Pentingnya Nutrisi Seimbang Selama Pengobatan',
                      Colors.blue.shade100,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildArticleCard(
                    'GAYA HIDUP',
                    'Olahraga Ringan Untuk Stamina',
                    Colors.orange.shade100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(String category, String title, Color color) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
