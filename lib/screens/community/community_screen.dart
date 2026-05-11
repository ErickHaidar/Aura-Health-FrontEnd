import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../core/theme/app_theme.dart';
import '../../core/config/api_config.dart';
import '../../models/post.dart';
import '../../services/community_service.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';
import '../../widgets/post_skeleton.dart';
import '../../widgets/comment_bottom_sheet.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  User? _user;
  io.Socket? _socket;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _connectRealtime();
  }

  @override
  void dispose() {
    _socket?.dispose();
    super.dispose();
  }

  void _connectRealtime() {
    _socket = io.io(
      ApiConfig.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .disableAutoConnect()
          .build(),
    );

    _socket!
      ..onConnect((_) {})
      ..on('post_created', (_) => _loadPosts())
      ..on('post_updated', (data) => _handleRealtimePostUpdated(data))
      ..on('post_deleted', (data) => _handleRealtimePostDeleted(data))
      ..on('post_liked', (_) => _loadPosts())
      ..on('comment_created', (_) => _loadPosts())
      ..on('comment_deleted', (_) => _loadPosts())
      ..connect();
  }

  void _handleRealtimePostUpdated(dynamic data) {
    if (!mounted || data is! Map || data['post'] == null) return;
    final updated = Post.fromJson(Map<String, dynamic>.from(data['post']));
    final index = _posts.indexWhere((post) => post.id == updated.id);
    if (index == -1) return;
    setState(() => _posts[index] = updated);
  }

  void _handleRealtimePostDeleted(dynamic data) {
    if (!mounted || data is! Map) return;
    final postId = data['postId']?.toString();
    if (postId == null) return;
    setState(() => _posts.removeWhere((post) => post.id == postId));
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

  Future<void> _handleLike(String postId, int index) async {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyukai post')));
    }
  }

  void _showComments(String postId, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, ctrl) => CommentBottomSheet(
          postId: postId,
          onCommentAdded: () {
            setState(() {
              final p = _posts[index];
              _posts[index] = p.copyWith(commentsCount: p.commentsCount + 1);
            });
          },
        ),
      ),
    );
  }

  Future<void> _editPost(Post post, int index) async {
    final controller = TextEditingController(text: post.content);
    final updatedContent = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Tulis perubahan post',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (updatedContent == null ||
        updatedContent.isEmpty ||
        updatedContent == post.content) {
      return;
    }

    final originalPost = _posts[index];
    setState(
      () => _posts[index] = originalPost.copyWith(content: updatedContent),
    );

    final result = await CommunityService.updatePost(post.id, updatedContent);
    if (!mounted) return;

    if (result['success'] == true) {
      setState(() => _posts[index] = result['post'] as Post);
    } else {
      setState(() => _posts[index] = originalPost);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal memperbarui post')),
      );
    }
  }

  Future<void> _confirmDeletePost(Post post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Post?'),
        content: const Text('Apakah Anda yakin ingin menghapus post ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final originalPosts = List<Post>.from(_posts);
    setState(() => _posts.removeWhere((item) => item.id == post.id));

    final result = await CommunityService.deletePost(post.id);
    if (!mounted) return;

    if (result['success'] != true) {
      setState(() => _posts = originalPosts);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal menghapus post')),
      );
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
          leading: const Icon(Icons.arrow_back),
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
                          ? CachedNetworkImageProvider(_user!.avatarUrl!)
                                as ImageProvider
                          : FileImage(
                                  File(
                                    _user!.avatarUrl!.replaceFirst(
                                      'file://',
                                      '',
                                    ),
                                  ),
                                )
                                as ImageProvider)
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
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Icon(Icons.forum_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada postingan.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Jadilah yang pertama berbagi!',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._posts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final post = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostDetailScreen(post: post),
                          ),
                        ).then((_) => _loadPosts()),
                        child: _buildPostCard(
                          postId: post.id,
                          index: index,
                          name: post.authorName,
                          time: _formatTime(post.createdAt),
                          content: post.content,
                          likes: post.likesCount,
                          comments: post.commentsCount,
                          isLiked: post.isLiked,
                          isOwnPost: post.isOwnPost,
                          isAnonymous: post.isAnonymous,
                          hasImage: post.imageUrl != null,
                          imageUrl: post.imageUrl,
                        ),
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

  Widget _buildPostCard({
    String? postId,
    int? index,
    required String name,
    required String time,
    required String content,
    required int likes,
    required int comments,
    bool isLiked = false,
    bool isOwnPost = false,
    bool isAnonymous = false,
    String? tag,
    bool hasImage = false,
    String? imageUrl,
  }) {
    final isAnonymousDisplay = isAnonymous && !isOwnPost;
    return Card(
      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      shadowColor: Colors.black.withValues(alpha: 0.04),
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
                      Row(
                        children: [
                          Text(
                            isAnonymousDisplay ? 'Anonim' : name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          if (isOwnPost && isAnonymous) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Anonim',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ),
                          ],
                        ],
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
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
                if (postId != null && index != null && isOwnPost)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      final post = _posts[index];
                      if (value == 'edit') _editPost(post, index);
                      if (value == 'delete') _confirmDeletePost(post);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
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
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorWidget: (_, _, _) => const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Image.file(
                                File(imageUrl.replaceFirst('file://', '')),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
