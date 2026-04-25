import 'package:flutter/material.dart';
import '../theme.dart';

class DetectionFlowScreen extends StatelessWidget {
  const DetectionFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
        title: const Text(
          'Alur & Lokasi Deteksi',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
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
                Text(
                  'Faskes Terdekat',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontSize: 24,
                  ),
                ),
                const Text(
                  'Lihat Semua',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Map Placeholder',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari puskesmas atau klinik...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Langkah-langkah Deteksi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            _buildStep(
              1,
              'Langkah 1: Cek Gejala Mandiri',
              'Screening awal untuk mengetahui risiko TB Anda melalui beberapa pertanyaan singkat.',
            ),
            _buildStep(
              2,
              'Langkah 2: Kunjungi Faskes',
              'Pemeriksaan fisik oleh tenaga medis di puskesmas atau klinik rujukan.',
            ),
            _buildStep(
              3,
              'Langkah 3: Tes Dahak (TCM)',
              'Pengambilan sampel dahak untuk pengujian Tes Cepat Molekuler (TCM).',
            ),
            _buildStep(
              4,
              'Langkah 4: Hasil Diagnosa',
              'Menerima dan berkonsultasi mengenai hasil tes TCM dari dokter.',
            ),
            _buildStep(
              5,
              'Langkah 5: Mulai Pengobatan',
              'Jika positif, memulai rejimen pengobatan TB di bawah pengawasan faskes.',
              isLast: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    int number,
    String title,
    String desc, {
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade300),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
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
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
