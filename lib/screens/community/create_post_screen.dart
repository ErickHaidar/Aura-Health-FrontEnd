import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../services/community_service.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const int _maxImageBytes = 1024 * 1024;
  final _contentController = TextEditingController();
  User? _currentUser;
  bool _isPosting = false;
  bool _isAnonymous = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String _loadingText = 'Mengunggah...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final result = await UserService.getMyProfile();
    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _currentUser = result['user'] as User;
        }
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

    final result = await CommunityService.createPost(
      content,
      isAnonymous: _isAnonymous,
      imagePath: _selectedImage?.path,
    );

    if (!mounted) return;
    setState(() => _isPosting = false);

    if (result['success'] == true) {
      // Simulate success delay for visual completion
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;

      Navigator.pop(context, result['post'] as Post? ?? true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal membuat post')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 70,
    );
    if (picked == null || !mounted) return;

    final file = File(picked.path);
    final size = await file.length();

    if (size > _maxImageBytes) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gunakan gambar maksimal 1 MB')),
      );
      return;
    }

    setState(() => _selectedImage = file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _currentUser?.avatarUrl != null
                        ? CachedNetworkImageProvider(_currentUser!.avatarUrl!)
                        : null,
                    child: _currentUser?.avatarUrl == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isAnonymous
                          ? 'Posting sebagai Anonim'
                          : _currentUser?.name ?? 'Pengguna Aura Health',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Apa yang ingin Anda bagikan hari ini?',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 12),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: _isPosting
                              ? null
                              : () => setState(() => _selectedImage = null),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _isAnonymous,
                onChanged: _isPosting
                    ? null
                    : (value) => setState(() => _isAnonymous = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Posting secara anonim',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Nama dan foto profil tidak akan ditampilkan ke pengguna lain.',
                ),
                activeColor: AppTheme.primaryColor,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _isPosting
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: _isPosting
                        ? null
                        : () => _pickImage(ImageSource.camera),
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
      ),
    );
  }
}
