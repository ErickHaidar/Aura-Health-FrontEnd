import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/education.dart';
import '../services/education_service.dart';
import 'article_detail_screen.dart';

class EducationCategoryScreen extends StatefulWidget {
  final String title;

  const EducationCategoryScreen({super.key, required this.title});

  @override
  State<EducationCategoryScreen> createState() => _EducationCategoryScreenState();
}

class _EducationCategoryScreenState extends State<EducationCategoryScreen> {
  List<EducationContent> _contents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final result = await EducationService.getContentByCategory(widget.title);

    if (!mounted) return;

    setState(() {
      if (result['success'] == true) {
        _contents = result['contents'] as List<EducationContent>;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : _contents.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Materi untuk ${widget.title}\nakan segera hadir.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _contents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final content = _contents[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          content.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            content.content.length > 100
                                ? '${content.content.substring(0, 100)}...'
                                : content.content,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppTheme.primaryColor,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailScreen(
                                defaultTitle: content.title,
                                defaultContent: content.content,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
