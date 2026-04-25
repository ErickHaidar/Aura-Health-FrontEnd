import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/post.dart';
import '../services/community_service.dart';
import 'create_post_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final result = await CommunityService.getPosts();

    if (!mounted) return;

    setState(() {
      if (result['success'] == true) {
        _posts = result['posts'] as List<Post>;
      }
      _isLoading = false;
    });
  }

  Future<void> _handleLike(int postId, int index) async {
    final result = await CommunityService.toggleLike(postId);
    if (result['success'] == true) {
      _loadPosts(); // Refresh data
    }
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari yang lalu';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return createdAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          title: const Text(
            'Aura Health',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _loadPosts,
          color: AppTheme.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
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
                            'Komunitas',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontSize: 28,
                                ),
                          ),
                          const Text(
                            'Bagikan ceritamu dan dukung sesama',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final created = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePostScreen(),
                          ),
                        );
                        if (created == true) _loadPosts();
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text(
                        'Buat\nPost',
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: AppTheme.primaryColor),
                    ),
                  )
                else if (_posts.isEmpty)
                  _buildStaticPosts()
                else
                  ..._posts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final post = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPostCard(
                        postId: post.id,
                        index: index,
                        name: post.authorName,
                        time: _formatTime(post.createdAt),
                        content: post.content,
                        likes: post.likesCount,
                        comments: post.commentsCount,
                        isLiked: post.isLiked,
                        hasImage: post.imageUrl != null,
                        imageUrl: post.imageUrl,
                      ),
                    );
                  }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaticPosts() {
    return Column(
      children: [
        _buildPostCard(
          name: 'Siti Rahmawati',
          time: '2 jam yang lalu',
          content:
              'Hari ini selesai minum obat bulan ke-3! Semangat teman-teman! Perjalanan masih panjang tapi aku yakin kita semua bisa sembuh.',
          likes: 24,
          comments: 5,
        ),
        const SizedBox(height: 16),
        _buildPostCard(
          name: 'Andi Saputra',
          time: '5 jam yang lalu',
          content:
              'Halo, mau tanya dong. Seminggu terakhir setelah minum obat perut rasanya agak mual. Apakah ada tips dari teman-teman?',
          likes: 12,
          comments: 8,
          tag: 'TANYA DOKTER',
        ),
      ],
    );
  }

  Widget _buildPostCard({
    int? postId,
    int? index,
    required String name,
    required String time,
    required String content,
    required int likes,
    required int comments,
    bool isLiked = false,
    String? tag,
    bool hasImage = false,
    String? imageUrl,
  }) {
    return Container(
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
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content),
          if (hasImage) ...[
            const SizedBox(height: 12),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image, size: 48, color: Colors.white),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 48, color: Colors.white),
                    ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: postId != null && index != null
                    ? () => _handleLike(postId, index)
                    : null,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$comments Komentar',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
