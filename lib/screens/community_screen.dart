import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:io';
import '../theme.dart';
import '../models/post.dart';
import '../services/community_service.dart';
import 'create_post_screen.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../widgets/post_skeleton.dart';
import '../widgets/comment_bottom_sheet.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final postFuture = CommunityService.getPosts();
    final userResult = await UserService.getLocalProfile();

    final postResult = await postFuture;

    if (!mounted) return;

    setState(() {
      if (postResult['success'] == true) {
        _posts = postResult['posts'] as List<Post>;
      }
      _user = userResult;
      _isLoading = false;
    });
  }

  Future<void> _handleLike(int postId, int index) async {
    final originalPost = _posts[index];
    final wasLiked = originalPost.isLiked;
    final currentLikes = originalPost.likesCount;

    // Optimistic UI update
    setState(() {
      _posts[index] = originalPost.copyWith(
        isLiked: !wasLiked,
        likesCount: wasLiked ? currentLikes - 1 : currentLikes + 1,
      );
    });

    final result = await CommunityService.toggleLike(postId);
    
    // Rollback if the API call fails
    if (result['success'] != true) {
      if (!mounted) return;
      setState(() {
        _posts[index] = originalPost;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyukai post')),
      );
    }
  }

  void _showComments(int postId, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: CommentBottomSheet(
          postId: postId,
          onCommentAdded: () {
            // Optimistic update for comment count
            setState(() {
              final p = _posts[index];
              _posts[index] = p.copyWith(commentsCount: p.commentsCount + 1);
            });
          },
        ),
      ),
    );
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                backgroundImage: _user?.avatarUrl != null
                    ? (_user!.avatarUrl!.startsWith('http')
                        ? NetworkImage(_user!.avatarUrl!) as ImageProvider
                        : FileImage(File(_user!.avatarUrl!.replaceFirst('file://', ''))) as ImageProvider)
                    : null,
                child: _user?.avatarUrl == null
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
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
                        final dynamic createdPost = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePostScreen(),
                          ),
                        );
                        
                        if (createdPost is Post) {
                          // Optimistic Add Post
                          setState(() {
                            _posts.insert(0, createdPost);
                          });
                          // Refresh in background to sync with server
                          _loadPosts();
                        } else if (createdPost == true) {
                          _loadPosts();
                        }
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
                  Column(
                    children: List.generate(3, (index) => const PostSkeleton()),
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
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      shadowColor: Colors.black.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (tag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            if (hasImage) ...[
              const SizedBox(height: 16),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imageUrl.startsWith('http')
                            ? Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.image, size: 48, color: Colors.grey),
                                ),
                              )
                            : Image.file(
                                File(imageUrl.replaceFirst('file://', '')),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.image, size: 48, color: Colors.grey),
                                ),
                              ),
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                InkWell(
                  onTap: postId != null && index != null
                      ? () => _handleLike(postId, index)
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$likes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isLiked ? Colors.red : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: postId != null && index != null
                      ? () => _showComments(postId, index)
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$comments Komentar',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
