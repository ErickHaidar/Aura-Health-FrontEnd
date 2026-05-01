import 'package:flutter/material.dart';
import 'dart:io';
import '../theme.dart';
import '../services/education_service.dart';
import '../models/education.dart';
import 'education_category_screen.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  List<EducationCategory> _categories = [];
  bool _isLoading = true;
  User? _user;

  // Fallback icons berdasarkan nama kategori
  static const _categoryIcons = {
    'mengenal tbc': Icons.coronavirus,
    'gejala': Icons.health_and_safety,
    'deteksi': Icons.health_and_safety,
    'pencegahan': Icons.shield,
    'obat': Icons.medication,
    'oat': Icons.medication,
    'etika batuk': Icons.record_voice_over,
    'nutrisi': Icons.restaurant,
  };

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final catFuture = EducationService.getCategories();
    final userFuture = UserService.getMyProfile();

    final catResult = await catFuture;
    final userResult = await userFuture;

    if (!mounted) return;

    setState(() {
      if (catResult['success'] == true) {
        _categories = catResult['categories'] as List<EducationCategory>;
      }
      if (userResult['success'] == true) {
        _user = userResult['user'] as User;
      }
      _isLoading = false;
    });
  }

  IconData _getIconForCategory(String name) {
    final lower = name.toLowerCase();
    for (final entry in _categoryIcons.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return Icons.menu_book;
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
            'Edukasi TBC',
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
                        : FileImage(File(_user!.avatarUrl!)) as ImageProvider)
                    : null,
                child: _user?.avatarUrl == null
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari topik edukasi...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Kategori Pembelajaran',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: AppTheme.primaryColor),
                  ),
                )
              else if (_categories.isNotEmpty)
                ..._categories.map((cat) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildCategoryCard(
                    context,
                    icon: _getIconForCategory(cat.name),
                    title: cat.name,
                    description: cat.description ?? 'Pelajari lebih lanjut tentang ${cat.name}.',
                  ),
                ))
              else
                ..._buildStaticCategories(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStaticCategories(BuildContext context) {
    return [
      _buildCategoryCard(
        context,
        icon: Icons.coronavirus,
        title: 'Mengenal TBC',
        description: 'Pahami dasar-dasar penyakit tuberkulosis.',
      ),
      const SizedBox(height: 16),
      _buildCategoryCard(
        context,
        icon: Icons.health_and_safety,
        title: 'Gejala & Deteksi',
        description: 'Kenali tanda-tanda awal dan cara pemeriksaannya.',
      ),
      const SizedBox(height: 16),
      _buildCategoryCard(
        context,
        icon: Icons.shield,
        title: 'Pencegahan',
        description: 'Langkah-langkah melindungi diri dan keluarga.',
        iconColor: Colors.brown,
      ),
      const SizedBox(height: 16),
      _buildCategoryCard(
        context,
        icon: Icons.medication,
        title: 'Obat-obatan OAT',
        description: 'Panduan lengkap pengobatan dan efek samping.',
      ),
      const SizedBox(height: 16),
      _buildCategoryCard(
        context,
        icon: Icons.record_voice_over,
        title: 'Etika Batuk',
        description: 'Cara batuk yang benar agar tidak menularkan ke orang lain.',
      ),
      const SizedBox(height: 16),
      _buildCategoryCard(
        context,
        icon: Icons.restaurant,
        title: 'Nutrisi TBC',
        description: 'Kebutuhan gizi bagi penderita TBC untuk mempercepat kesembuhan.',
      ),
    ];
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    Color iconColor = AppTheme.primaryColor,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EducationCategoryScreen(title: title),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
