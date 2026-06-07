import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/community_service.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../services/user_service.dart';
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  User? _currentUser;
  bool _isPosting = false;
  String _loadingText = 'Mengunggah...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await UserService.getLocalProfile();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handlePost() async {
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tulis sesuatu terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isPosting = true;
      _loadingText = 'Menyiapkan post...';
    });

    // Progress Illusion Simulation
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _loadingText = 'Mengunggah konten...');
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _loadingText = 'Menyelesaikan...');

    final result = await CommunityService.createPost(content);

    if (!mounted) return;
    setState(() => _isPosting = false);

    if (result['success'] == true) {
      // Simulate success delay for visual completion
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      
      // Return the new post data to support optimistic UI on the caller side
      // Since createPost doesn't return the full Post object, we can construct a local mock
      // to pass back, which will be added to the feed immediately.
      final newPostMock = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // temporary ID
        content: content,
        authorName: _currentUser?.name ?? 'Pengguna Aura Health',
        authorAvatar: _currentUser?.avatarUrl,
        likesCount: 0,
        commentsCount: 0,
        isLiked: false,
        createdAt: DateTime.now().toIso8601String(),
      );
      Navigator.pop(context, newPostMock);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal membuat post')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Buat Post',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _isPosting ? null : _handlePost,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 0),
              ),
              child: _isPosting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Kirim'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _currentUser?.avatarUrl != null
                      ? NetworkImage(_currentUser!.avatarUrl!)
                      : null,
                  child: _currentUser?.avatarUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  _currentUser?.name ?? 'Pengguna Aura Health',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Apa yang ingin Anda bagikan hari ini?',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: AppTheme.primaryColor),
                  onPressed: () {
                    // TODO: Implement image picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur upload gambar akan segera hadir')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur kamera akan segera hadir')),
                    );
                  },
                ),
              ],
            ),
            if (_isPosting) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                backgroundColor: Colors.grey.shade200,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _loadingText,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
