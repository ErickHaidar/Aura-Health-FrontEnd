import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'user_service.dart';

class CommunityService {
  // ─── Local Mock Data ───
  static final List<Post> _localPosts = [
    Post(
      id: 1,
      content: 'Hari ini selesai minum obat bulan ke-3! Semangat teman-teman! Perjalanan masih panjang tapi aku yakin kita semua bisa sembuh.',
      authorName: 'Siti Rahmawati',
      likesCount: 24,
      commentsCount: 2,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    ),
    Post(
      id: 2,
      content: 'Halo, mau tanya dong. Seminggu terakhir setelah minum obat perut rasanya agak mual. Apakah ada tips dari teman-teman?',
      authorName: 'Andi Saputra',
      likesCount: 12,
      commentsCount: 1,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
    ),
  ];

  static final Map<int, List<Comment>> _localComments = {
    1: [
      Comment(
        id: 101,
        comment: 'Wah hebat mbak Siti! Lanjutkan!',
        authorName: 'Budi Santoso',
        isLiked: true,
        likesCount: 5,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
      ),
      Comment(
        id: 102,
        comment: 'Semangat terus, pasti bisa!',
        authorName: 'Ratna Dewi',
        isLiked: false,
        likesCount: 2,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
      ),
    ],
    2: [
      Comment(
        id: 103,
        comment: 'Biasanya karena perut kosong, coba makan dulu sebelum minum obat mas.',
        authorName: 'Dr. Hendra',
        isLiked: true,
        likesCount: 10,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      ),
    ],
  };

  // ─── Feed semua post (publik) ───
  static Future<Map<String, dynamic>> getPosts({int page = 1, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Mock latency
    return {'success': true, 'posts': List<Post>.from(_localPosts)};
  }

  // ─── Detail post ───
  static Future<Map<String, dynamic>> getPostDetail(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final postIndex = _localPosts.indexWhere((p) => p.id == id);
    if (postIndex != -1) {
      return {'success': true, 'post': _localPosts[postIndex]};
    }
    return {'success': false, 'message': 'Post tidak ditemukan'};
  }

  // ─── Buat post ───
  static Future<Map<String, dynamic>> createPost(String content, {String? imagePath}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final user = await UserService.getLocalProfile();
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch,
      content: content,
      authorName: user?.name ?? 'Pengguna Aura Health',
      authorAvatar: user?.avatarUrl,
      imageUrl: imagePath,
      likesCount: 0,
      commentsCount: 0,
      isLiked: false,
      createdAt: DateTime.now().toIso8601String(),
    );
    _localPosts.insert(0, newPost);
    return {'success': true, 'message': 'Post berhasil dibuat', 'post': newPost};
  }

  // ─── Hapus post ───
  static Future<Map<String, dynamic>> deletePost(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _localPosts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _localPosts.removeAt(index);
      _localComments.remove(id);
      return {'success': true, 'message': 'Post dihapus'};
    }
    return {'success': false, 'message': 'Post tidak ditemukan'};
  }

  // ─── Like / Unlike post ───
  static Future<Map<String, dynamic>> toggleLike(int postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _localPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _localPosts[index];
      _localPosts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
      return {'success': true, 'message': 'Berhasil'};
    }
    return {'success': false, 'message': 'Post tidak ditemukan'};
  }

  // ─── Ambil komentar post ───
  static Future<Map<String, dynamic>> getComments(int postId, {int page = 1, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final comments = _localComments[postId] ?? [];
    return {'success': true, 'comments': List<Comment>.from(comments)};
  }

  // ─── Tambah komentar ───
  static Future<Map<String, dynamic>> addComment(int postId, String commentText) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final user = await UserService.getLocalProfile();
    
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      comment: commentText,
      authorName: user?.name ?? 'Pengguna',
      authorAvatar: user?.avatarUrl,
      isLiked: false,
      likesCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    );

    if (_localComments.containsKey(postId)) {
      _localComments[postId]!.insert(0, newComment);
    } else {
      _localComments[postId] = [newComment];
    }

    // Update post comment count
    final postIndex = _localPosts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _localPosts[postIndex];
      _localPosts[postIndex] = post.copyWith(commentsCount: post.commentsCount + 1);
    }

    return {'success': true, 'message': 'Komentar ditambahkan', 'comment': newComment};
  }

  // ─── Hapus komentar ───
  static Future<Map<String, dynamic>> deleteComment(int postId, int commentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_localComments.containsKey(postId)) {
      final index = _localComments[postId]!.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        _localComments[postId]!.removeAt(index);
        
        // Update post comment count
        final postIndex = _localPosts.indexWhere((p) => p.id == postId);
        if (postIndex != -1) {
          final post = _localPosts[postIndex];
          _localPosts[postIndex] = post.copyWith(commentsCount: post.commentsCount - 1);
        }
        
        return {'success': true, 'message': 'Komentar dihapus'};
      }
    }
    return {'success': false, 'message': 'Komentar tidak ditemukan'};
  }

  // ─── Like / Unlike komentar ───
  static Future<Map<String, dynamic>> toggleCommentLike(int postId, int commentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_localComments.containsKey(postId)) {
      final index = _localComments[postId]!.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        final comment = _localComments[postId]![index];
        _localComments[postId]![index] = comment.copyWith(
          isLiked: !comment.isLiked,
          likesCount: comment.isLiked ? comment.likesCount - 1 : comment.likesCount + 1,
        );
        return {'success': true, 'message': 'Berhasil'};
      }
    }
    return {'success': false, 'message': 'Komentar tidak ditemukan'};
  }
}