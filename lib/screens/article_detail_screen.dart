import 'package:flutter/material.dart';
import '../theme.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.image, size: 64, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'NUTRITION',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '5 min read',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pentingnya Nutrisi Seimbang Selama Pengobatan',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Menjalani pengobatan TBC membutuhkan energi ekstra. Pelajari bagaimana makanan yang tepat dapat mempercepat proses penyembuhan Anda.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pengobatan tuberkulosis (TBC) adalah perjalanan yang panjang dan seringkali menantang. Selain mengonsumsi obat secara teratur, asupan nutrisi memegang peranan vital dalam proses penyembuhan. Tubuh yang sedang melawan infeksi membutuhkan lebih banyak kalori dan nutrisi spesifik untuk memperbaiki jaringan yang rusak dan memperkuat sistem kekebalan tubuh.',
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: AppTheme.primaryColor,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Fakta Kunci',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Malnutrisi dapat menurunkan efektivitas obat TBC dan memperpanjang masa pemulihan. Berat badan yang ideal sangat penting untuk dipertahankan selama masa pengobatan.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Makronutrien Utama',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Untuk membangun kembali kekuatan, pasien TBC disarankan untuk fokus pada makronutrien berikut:',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '• Protein Tinggi: Penting untuk perbaikan sel dan produksi antibodi.',
                  ),
                  const Text(
                    '• Karbohidrat Kompleks: Memberikan energi berkelanjutan.',
                  ),
                  const Text('• Lemak Sehat: Membantu penyerapan vitamin.'),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.thumb_up_alt_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Membantu (24)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('Bagikan Artikel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryLight,
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
