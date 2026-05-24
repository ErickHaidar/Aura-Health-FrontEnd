import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'dart:io';
import '../models/post.dart';
import '../models/user.dart';
import '../services/community_service.dart';
import '../services/user_service.dart';
import '../theme.dart';

class CommentBottomSheet extends StatefulWidget {
  final int postId;
  final VoidCallback onCommentAdded;
=======
import '../models/post.dart';
import '../services/community_service.dart';
import '../core/theme/app_theme.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;
  final VoidCallback? onCommentAdded;
>>>>>>> rizqi0

  const CommentBottomSheet({
    super.key,
    required this.postId,
<<<<<<< HEAD
    required this.onCommentAdded,
=======
    this.onCommentAdded,
>>>>>>> rizqi0
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _commentController = TextEditingController();
<<<<<<< HEAD
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
  User? _currentUser;
=======
  final _scrollController = ScrollController();
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
>>>>>>> rizqi0

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadData();
=======
    _loadComments();
>>>>>>> rizqi0
  }

  @override
  void dispose() {
    _commentController.dispose();
<<<<<<< HEAD
    super.dispose();
  }

  Future<void> _loadData() async {
    final commentsFuture = CommunityService.getComments(widget.postId);
    final userFuture = UserService.getLocalProfile();

    final commentsResult = await commentsFuture;
    final user = await userFuture;

    if (!mounted) return;

    setState(() {
      if (commentsResult['success'] == true) {
        _comments = commentsResult['comments'] as List<Comment>;
      }
      _currentUser = user;
=======
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    final result = await CommunityService.getComments(widget.postId, limit: 100);
    if (!mounted) return;
    setState(() {
      if (result['success'] == true) {
        _comments = result['comments'] as List<Comment>;
      }
>>>>>>> rizqi0
      _isLoading = false;
    });
  }

<<<<<<< HEAD
  Future<void> _handleAddComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isPosting = true;
    });

    final result = await CommunityService.addComment(widget.postId, text);
    
    if (!mounted) return;
    setState(() {
      _isPosting = false;
    });

    if (result['success'] == true) {
      _commentController.clear();
      // Optimistic add (with mock ID until refresh)
      setState(() {
        _comments.insert(
          0,
          Comment(
            id: DateTime.now().millisecondsSinceEpoch,
            comment: text,
            authorName: _currentUser?.name ?? 'Pengguna',
            authorAvatar: _currentUser?.avatarUrl,
            isLiked: false,
            likesCount: 0,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
      });
      widget.onCommentAdded();
=======
  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isPosting) return;

    setState(() => _isPosting = true);
    final result = await CommunityService.addComment(widget.postId, text);

    if (!mounted) return;
    setState(() => _isPosting = false);

    if (result['success'] == true) {
      _commentController.clear();
      widget.onCommentAdded?.call();
      await _loadComments();
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
>>>>>>> rizqi0
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal menambah komentar')),
      );
    }
  }

<<<<<<< HEAD
  Future<void> _handleLikeComment(int index) async {
    final originalComment = _comments[index];
    final wasLiked = originalComment.isLiked;
    final currentLikes = originalComment.likesCount;

    // Optimistic Update
    setState(() {
      _comments[index] = originalComment.copyWith(
        isLiked: !wasLiked,
        likesCount: wasLiked ? currentLikes - 1 : currentLikes + 1,
      );
    });

    final result = await CommunityService.toggleCommentLike(widget.postId, originalComment.id);

    // Rollback if failed
    if (result['success'] != true) {
      if (!mounted) return;
      setState(() {
        _comments[index] = originalComment;
      });
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 48,
            height: 6,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            'Komentar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          // Comment list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                : _comments.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada komentar. Jadilah yang pertama!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: comment.authorAvatar != null
                                      ? (comment.authorAvatar!.startsWith('http')
                                          ? NetworkImage(comment.authorAvatar!) as ImageProvider
                                          : FileImage(File(comment.authorAvatar!.replaceFirst('file://', ''))))
                                      : null,
                                  child: comment.authorAvatar == null
                                      ? const Icon(Icons.person, size: 20, color: Colors.grey)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            comment.authorName,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _formatTime(comment.createdAt),
                                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(comment.comment, style: const TextStyle(fontSize: 14)),
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
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          const Divider(height: 1),
          // Input field
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _currentUser?.avatarUrl != null
                      ? (_currentUser!.avatarUrl!.startsWith('http')
                          ? NetworkImage(_currentUser!.avatarUrl!) as ImageProvider
                          : FileImage(File(_currentUser!.avatarUrl!.replaceFirst('file://', ''))))
                      : null,
                  child: _currentUser?.avatarUrl == null
                      ? const Icon(Icons.person, size: 20, color: Colors.grey)
                      : null,
                ),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      suffixIcon: _isPosting
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor),
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
=======
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Komentar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  if (_comments.isNotEmpty)
                    Text(
                      '${_comments.length}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Comments list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _comments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.comment_outlined,
                                  size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text(
                                'Belum ada komentar.\nJadi yang pertama!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _comments.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (ctx, i) => _buildCommentTile(_comments[i]),
                        ),
            ),
            // Input
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 8,
                bottom: 12 + mq.padding.bottom + mq.viewInsets.bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submitComment(),
                      decoration: InputDecoration(
                        hintText: 'Tulis komentar...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isPosting
                      ? const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          onPressed: _submitComment,
                          icon: const Icon(Icons.send_rounded),
                          color: AppTheme.primaryColor,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: comment.authorAvatar != null
              ? NetworkImage(comment.authorAvatar!)
              : null,
          child: comment.authorAvatar == null
              ? const Icon(Icons.person, size: 18, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.authorName,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(comment.comment, style: const TextStyle(fontSize: 14)),
              if (comment.createdAt != null)
                Text(
                  _formatTime(comment.createdAt!),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inHours < 1) return '${diff.inMinutes} menit lalu';
      if (diff.inDays < 1) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
>>>>>>> rizqi0
}
