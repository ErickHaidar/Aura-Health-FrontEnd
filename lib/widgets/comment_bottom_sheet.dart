import 'package:flutter/material.dart';
import 'dart:io';
import '../models/post.dart';
import '../models/user.dart';
import '../services/community_service.dart';
import '../services/user_service.dart';
import '../theme.dart';

class CommentBottomSheet extends StatefulWidget {
  final int postId;
  final VoidCallback onCommentAdded;

  const CommentBottomSheet({
    super.key,
    required this.postId,
    required this.onCommentAdded,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _commentController.dispose();
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
      _isLoading = false;
    });
  }

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal menambah komentar')),
      );
    }
  }

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
}
