import 'package:flutter/material.dart';
import '../theme.dart';
import 'create_post_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              child: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Komunitas',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontSize: 28,
                              ),
                        ),
                        const Text(
                          'Bagikan ceritamu dan dukung sesama',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePostScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text(
                      'Buat\nPost',
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: const Size(0, 0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildPostCard(
                name: 'Siti Rahmawati',
                time: '2 jam yang lalu',
                content:
                    'Hari ini selesai minum obat bulan ke-3! Semangat teman-teman! Perjalanan masih panjang tapi aku yakin kita semua bisa sembuh. Jangan lupa minum air putih yang banyak ya ????',
                likes: 24,
                comments: 5,
              ),
              const SizedBox(height: 16),
              _buildPostCard(
                name: 'Andi Saputra',
                time: '5 jam yang lalu',
                content:
                    'Halo, mau tanya dong. Seminggu terakhir setelah minum obat perut rasanya agak mual. Apakah ada tips dari teman-teman untuk mengurangi rasa mualnya? Terima kasih.',
                likes: 12,
                comments: 8,
                tag: 'TANYA DOKTER',
              ),
              const SizedBox(height: 16),
              _buildPostCard(
                name: 'Maya Indah',
                time: 'Kemarin',
                content:
                    'Jalan pagi hari ini udara segar sekali! Sangat membantu untuk pernapasan. Jangan lupa olahraga ringan ya teman-teman. ???????',
                likes: 45,
                comments: 2,
                hasImage: true,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard({
    required String name,
    required String time,
    required String content,
    required int likes,
    required int comments,
    String? tag,
    bool hasImage = false,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content),
          if (hasImage) ...[
            const SizedBox(height: 12),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 48, color: Colors.white),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$comments Komentar',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
