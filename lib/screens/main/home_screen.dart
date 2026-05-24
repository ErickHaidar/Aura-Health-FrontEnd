import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../../models/article.dart';
import '../../services/article_service.dart';
import '../assistant/chatbot_screen.dart';
import '../detection/detection_flow_screen.dart';
import '../article/article_detail_screen.dart';
import '../article/article_list_screen.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> _articles = [];
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userFuture = UserService.getMyProfile();
    final articleFuture = ArticleService.getArticles(limit: 10);

    final userResult = await userFuture;
    final articleResult = await articleFuture;

    if (!mounted) return;

    setState(() {
      if (userResult['success'] == true) {
        _user = userResult['user'] as User;
      }
      if (articleResult['success'] == true) {
        _articles = articleResult['articles'] as List<Article>;
      }
      _isLoading = false;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${_getGreeting()}!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontSize: 24,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _user?.name ?? 'Pengguna Aura Health',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _user?.avatarUrl != null
                      ? (_user!.avatarUrl!.startsWith('http')
                            ? CachedNetworkImageProvider(_user!.avatarUrl!)
                                  as ImageProvider
                            : FileImage(File(_user!.avatarUrl!))
                                  as ImageProvider)
                      : null,
                  child: _user?.avatarUrl == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('Layanan Kami', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.08,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildServiceCard(
                  context,
                  Icons.menu_book,
                  'Edukasi TBC',
                  tabIndex: 1,
                  isHighlighted: true,
                ),
                _buildServiceCard(
                  context,
                  Icons.manage_search,
                  'Alur Deteksi',
                  screen: const DetectionFlowScreen(),
                ),
                _buildServiceCard(
                  context,
                  Icons.people,
                  'Komunitas',
                  tabIndex: 2,
                ),
                _buildServiceCard(
                  context,
                  Icons.smart_toy,
                  'Chatbot AI',
                  screen: const ChatbotScreen(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Artikel Terbaru',
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ArticleListScreen(),
                      ),
                    );
                  },
                  child: const Text('Lihat Semua', style: TextStyle()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : _articles.isEmpty
                ? const Center(child: Text('Belum ada artikel'))
                : SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _articles.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final article = _articles[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleDetailScreen(articleId: article.id.toString()),
                            ),
                          ),
                          child: _buildArticleCard(article),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    IconData icon,
    String label, {
    Widget? screen,
    int? tabIndex,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (tabIndex != null && widget.onNavigateTab != null) {
          widget.onNavigateTab!(tabIndex);
          return;
        }
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppTheme.primaryLight
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(Article article) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: article.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: article.imageUrl!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Container(height: 100, color: Colors.grey.shade300),
                  )
                : Container(height: 100, color: Colors.teal.shade100),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        article.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 14, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          '${article.likesCount}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  article.title,
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
