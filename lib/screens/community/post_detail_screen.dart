import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../core/theme/app_theme.dart';
import '../../core/config/api_config.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/community_service.dart';
import '../../services/user_service.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  late Post _post;
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
  User? _currentUser;
  io.Socket? _socket;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadData();
    _connectRealtime();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
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
      ..on('comment_created', (data) {
        if (data is Map && data['postId']?.toString() == _post.id) {
          _loadData();
        }
      })
      ..on('comment_deleted', (data) {
        if (data is Map && data['postId']?.toString() == _post.id) {
          _loadData();
        }
      })
      ..on('post_liked', (_) => _refreshPost())
      ..connect();
  }

  Future<void> _refreshPost() async {
    final result = await CommunityService.getPosts();
    if (!mounted || result['success'] != true) return;
    final posts = result['posts'] as List<Post>;
    final updated = posts.where((p) => p.id == _post.id).toList();
    if (updated.isNotEmpty) setState(() => _post = updated.first);
  }

  Future<void> _loadData() async {
    final commentsFuture = CommunityService.getComments(_post.id);
    final userFuture = UserService.getLocalProfile();

    final commentsResult = await commentsFuture;
    final user = await userFuture;

    if (!mounted) return;
    setState(() {
      if (commentsResult['success'] == true) {
        _comments = commentsResult['comments'] as List<Comment>;
      }
      _currentUser = user;
      _isLoading = false;
    });
  }

  Future<void> _handleLike() async {
    final wasLiked = _post.isLiked;
    setState(() {
      _post = _post.copyWith(
        isLiked: !wasLiked,
        likesCount: wasLiked ? _post.likesCount - 1 : _post.likesCount + 1,
      );
    });

    final result = await CommunityService.toggleLike(_post.id);
    if (!mounted) return;
    if (result['success'] != true) {
      setState(() {
        _post = _post.copyWith(
          isLiked: wasLiked,
          likesCount: wasLiked ? _post.likesCount + 1 : _post.likesCount - 1,
        );
      });
    }
  }

  Future<void> _handleAddComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isPosting = true);

    final result = await CommunityService.addComment(_post.id, text);

    if (!mounted) return;
    setState(() => _isPosting = false);

    if (result['success'] == true) {
      _commentController.clear();
      setState(() {
        _comments.insert(
          0,
          Comment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            comment: text,
            authorName: _currentUser?.name ?? 'Pengguna',
            authorAvatar: _currentUser?.avatarUrl,
            isLiked: false,
            likesCount: 0,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
        _post = _post.copyWith(commentsCount: _post.commentsCount + 1);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal menambah komentar')),
      );
    }
  }

  Future<void> _handleLikeComment(int index) async {
    final original = _comments[index];
    final wasLiked = original.isLiked;
    setState(() {
      _comments[index] = original.copyWith(
        isLiked: !wasLiked,
        likesCount: wasLiked ? original.likesCount - 1 : original.likesCount + 1,
      );
    });

    final result = await CommunityService.toggleCommentLike(_post.id, original.id);
    if (result['success'] != true && mounted) {
      setState(() => _comments[index] = original);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyukai komentar')),
      );
    }
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return createdAt;
    }
  }

  Widget _buildAvatar(String? avatarUrl, double radius) {
    final hasUrl = avatarUrl != null;
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: hasUrl
          ? (avatarUrl.startsWith('http')
              ? CachedNetworkImageProvider(avatarUrl) as ImageProvider
              : FileImage(File(avatarUrl.replaceFirst('file://', ''))))
          : null,
      child: !hasUrl
          ? Icon(Icons.person, size: radius, color: Colors.grey)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isAnonymousDisplay = _post.isAnonymous && !_post.isOwnPost;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Post',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(
                      isAnonymousDisplay ? null : _post.authorAvatar,
                      22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAnonymousDisplay ? 'Anonim' : _post.authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            _formatTime(_post.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _post.content,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
                if (_post.imageUrl != null) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _post.imageUrl!.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: _post.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => const SizedBox(
                              height: 180,
                              child: Center(
                                child: Icon(Icons.image, size: 48, color: Colors.grey),
                              ),
                            ),
                          )
                        : Image.file(
                            File(_post.imageUrl!.replaceFirst('file://', '')),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: _handleLike,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              _post.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _post.isLiked ? Colors.red : Colors.grey.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${_post.likesCount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _post.isLiked ? Colors.red : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, color: Colors.grey.shade600, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '${_post.commentsCount} Komentar',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(color: AppTheme.primaryColor),
                    ),
                  )
                else if (_comments.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Belum ada komentar. Jadilah yang pertama!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ..._comments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final comment = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAvatar(comment.authorAvatar, 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.authorName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTime(comment.createdAt),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(comment.comment, style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => _handleLikeComment(index),
                                child: Icon(
                                  comment.isLiked ? Icons.favorite : Icons.favorite_border,
                                  size: 16,
                                  color: comment.isLiked ? Colors.red : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${comment.likesCount}',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: 8 + bottomInset,
            ),
            child: Row(
              children: [
                _buildAvatar(_currentUser?.avatarUrl, 18),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      suffixIcon: _isPosting
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.send, color: AppTheme.primaryColor),
                              onPressed: _handleAddComment,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
