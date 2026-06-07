import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../models/article.dart';
import '../../services/article_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String? articleId;
  final String? defaultTitle;
  final String? defaultContent;

  const ArticleDetailScreen({
    super.key,
    this.articleId,
    this.defaultTitle,
    this.defaultContent,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  Article? _article;
  bool _isLoading = true;
  bool _isLiking = false;

  @override
  void initState() {
    super.initState();
    if (widget.articleId != null) {
      _loadArticle();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadArticle() async {
    final result = await ArticleService.getArticleDetail(widget.articleId!);

    if (!mounted) return;

    setState(() {
      if (result['success'] == true) {
        _article = result['article'] as Article;
      }
      _isLoading = false;
    });
  }

  Future<void> _onLike() async {
    if (_article == null || _isLiking) return;
    setState(() => _isLiking = true);

    final messenger = ScaffoldMessenger.of(context);
    final res = await ArticleService.likeArticle(_article!.id);

    if (!mounted) return;
    setState(() => _isLiking = false);

    if (res['success'] == true) {
      if (res['article'] != null) {
        setState(() {
          _article = res['article'] as Article;
        });
      }
      final liked = res['liked'] as bool? ?? _article!.isLiked;
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                liked ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                liked
                    ? 'Artikel disukai! (${_article!.likesCount} suka)'
                    : 'Batal menyukai artikel',
              ),
            ],
          ),
          backgroundColor: liked ? Colors.red.shade400 : Colors.grey.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Gagal menyukai artikel'),
          backgroundColor: Colors.grey.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onShare(String? sourceUrl) {
    final title = _article?.title ?? widget.defaultTitle ?? 'Artikel';
    final shareText = sourceUrl != null
        ? '$title\n\nBaca selengkapnya: $sourceUrl'
        : title;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bagikan Artikel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _shareOption(
              icon: Icons.copy,
              color: AppTheme.primaryColor,
              label: 'Salin Judul & Link',
              onTap: () {
                Clipboard.setData(ClipboardData(text: shareText));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text('Disalin ke clipboard!'),
                      ],
                    ),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            if (sourceUrl != null) ...[
              const SizedBox(height: 12),
              _shareOption(
                icon: Icons.open_in_browser,
                color: Colors.blue.shade600,
                label: 'Buka di Browser',
                onTap: () async {
                  Navigator.pop(ctx);
                  final url = Uri.parse(sourceUrl);
                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (_) {}
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _shareOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final title = _article?.title ?? widget.defaultTitle ?? 'Artikel';
    final category = (_article?.category ?? 'Artikel').toUpperCase();

    String? publishedInfo;
    if (_article?.createdAt != null) {
      try {
        final date = DateTime.parse(_article!.createdAt!).toLocal();
        publishedInfo = 'Diterbitkan ${date.day}/${date.month}/${date.year}';
      } catch (_) {
        publishedInfo = _article!.createdAt;
      }
    }

    var contentText = _article?.content ?? widget.defaultContent ?? '';

    String? sourceUrl;
    final sourceMatch = RegExp(
      r'(Sumber|Sumber Resmi):\s*(https?://[^\s]+)',
    ).firstMatch(contentText);
    if (sourceMatch != null) {
      sourceUrl = sourceMatch.group(2);
      contentText = contentText.replaceAll(sourceMatch.group(0)!, '').trim();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Aura Health',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Bagikan',
            onPressed: () => _onShare(sourceUrl),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 220,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: _article?.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: _article!.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.article_outlined,
                          size: 64,
                          color: AppTheme.primaryColor,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (publishedInfo != null)
                  Expanded(
                    child: Text(
                      publishedInfo,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const Text(
                    '5 min read',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            if (_article?.author != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _article!.author!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            Text(
              contentText,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),

            if (sourceUrl != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(sourceUrl!);
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tidak dapat membuka browser')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.open_in_browser, size: 18),
                  label: const Text('Baca Artikel Lengkap'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _onLike,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: (_article?.isLiked ?? false)
                            ? Colors.red.shade100
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (_article?.isLiked ?? false)
                              ? Colors.red.shade300
                              : Colors.red.shade100,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isLiking
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.red.shade400,
                                  ),
                                )
                              : Icon(
                                  (_article?.isLiked ?? false)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 18,
                                  color: Colors.red.shade400,
                                ),
                          const SizedBox(width: 8),
                          Text(
                            (_article?.isLiked ?? false)
                                ? 'Disukai (${_article?.likesCount ?? 0})'
                                : 'Suka (${_article?.likesCount ?? 0})',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onShare(sourceUrl),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.teal.shade100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share_outlined,
                            size: 18,
                            color: Colors.teal.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Bagikan',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
