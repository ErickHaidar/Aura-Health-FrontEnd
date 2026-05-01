import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/article.dart';
import '../services/article_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final int? articleId;
  final String? defaultTitle;
  final String? defaultContent;

  const ArticleDetailScreen({super.key, this.articleId, this.defaultTitle, this.defaultContent});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  Article? _article;
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
      );
    }

    final title = _article?.title ?? widget.defaultTitle ?? 'Pentingnya Nutrisi Seimbang Selama Pengobatan';
    final category = _article?.category.toUpperCase() ?? 'NUTRITION';
    final summary = _article != null 
        ? 'Diterbitkan pada ${_article!.createdAt ?? 'Baru-baru ini'}'
        : 'Informasi edukasi terpercaya mengenai TBC untuk membantu Anda memahami ${title.toLowerCase()}.';
    
    // Hide Fact Key if it's the hardcoded nutrition one and we aren't in nutrition category
    final showExtraDetails = category.toUpperCase() == 'NUTRISI TBC' || category.toUpperCase() == 'NUTRITION';
    final contentText = _article?.content ?? widget.defaultContent ??
        'Pengobatan tuberkulosis (TBC) adalah perjalanan yang panjang dan seringkali menantang. Selain mengonsumsi obat secara teratur, asupan nutrisi memegang peranan vital dalam proses penyembuhan. Tubuh yang sedang melawan infeksi membutuhkan lebih banyak kalori dan nutrisi spesifik untuk memperbaiki jaringan yang rusak dan memperkuat sistem kekebalan tubuh.';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Aura Health',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.bookmark_border, color: AppTheme.primaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 220,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: _article?.imageUrl != null
                    ? Image.network(
                        _article!.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image, size: 64, color: Colors.grey),
                        ),
                      )
                    // Fallback to static food image representation
                    : Image.network(
                        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.restaurant, size: 64, color: Colors.grey),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Tags and Read Time
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
                const Text(
                  '5 min read',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            
            // Summary Paragraph
            Text(
              summary,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            
            // Content Paragraph
            Text(
              contentText,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),
            
            if (showExtraDetails) ...[
              const SizedBox(height: 24),
              
              // Fakta Kunci Block
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fakta Kunci',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Malnutrisi dapat menurunkan efektivitas obat TBC dan memperpanjang masa pemulihan. Berat badan yang ideal sangat penting untuk dipertahankan selama masa pengobatan.',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Makronutrien Utama Header
              const Text(
                'Makronutrien Utama',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Untuk membangun kembali kekuatan, pasien TBC disarankan untuk fokus pada makronutrien berikut:',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 12),
              
              // Bullets
              _buildBulletPoint('Protein Tinggi: ', 'Penting untuk perbaikan sel dan produksi antibodi. Sumber yang direkomendasikan termasuk telur, ikan, daging tanpa lemak, tempe, dan tahu.'),
              _buildBulletPoint('Karbohidrat Kompleks: ', 'Memberikan energi berkelanjutan untuk melawan kelelahan kronis. Pilih nasi merah, oatmeal, dan ubi jalar.'),
              _buildBulletPoint('Lemak Sehat: ', 'Membantu penyerapan vitamin dan memberikan energi padat. Alpukat, kacang-kacangan, dan minyak zaitun adalah pilihan sangat baik.'),
              const SizedBox(height: 24),
              
              // Mikronutrien Header
              const Text(
                'Mikronutrien yang Tidak Boleh Dilewatkan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Vitamin dan mineral berperan sebagai katalis dalam proses pemulihan. Pastikan diet Anda kaya akan:',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              
              // Icon Cards
              _buildIconCard(
                Icons.wb_sunny_outlined,
                'Vitamin D',
                'Krusial untuk respon imun terhadap bakteri TB. Dapatkan dari sinar matahari pagi dan ikan berlemak.',
              ),
              const SizedBox(height: 12),
              _buildIconCard(
                Icons.water_drop_outlined,
                'Zat Besi & Seng',
                'Mencegah anemia yang umum terjadi pada pasien TBC dan mempercepat penyembuhan jaringan.',
              ),
              const SizedBox(height: 24),
              
              // Kesimpulan Header
              const Text(
                'Kesimpulan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Mengubah pola makan mungkin terasa sulit, terutama jika nafsu makan berkurang akibat efek samping obat. Mulailah dengan porsi kecil namun sering, dan fokus pada makanan padat nutrisi. Konsultasikan dengan ahli gizi Anda untuk membuat rencana makan yang sesuai dengan kondisi dan toleransi tubuh Anda.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
            const SizedBox(height: 40),
            
            // Bottom Buttons
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.teal.shade700),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Membantu (24)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Bagikan Artikel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade100,
                  foregroundColor: Colors.teal.shade800,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String boldText, String normalText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: boldText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: normalText),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal.shade700),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.4,
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

