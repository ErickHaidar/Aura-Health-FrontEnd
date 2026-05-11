import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../models/education.dart';

class EducationDetailScreen extends StatelessWidget {
  final EducationContent content;

  const EducationDetailScreen({super.key, required this.content});

  void _share(BuildContext context) {
    final shareText = '${content.title}\n\n${content.content}';
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
              'Bagikan Edukasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              content.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: shareText));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edukasi disalin ke clipboard')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.copy, color: AppTheme.primaryColor, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'Salin Materi Edukasi',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  List<String> _paragraphs() {
    return content.content
        .split(RegExp(r'\n\s*\n'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
  }

  Widget _professionalSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Materi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          _infoRow('Kategori', content.category),
          _infoRow(
            'Tujuan',
            'Membantu pasien dan keluarga memahami langkah perawatan dengan aman.',
          ),
          _infoRow(
            'Catatan',
            'Gunakan materi ini sebagai pendamping edukasi tenaga kesehatan.',
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }

  List<String> _contextualSteps() {
    final text = '${content.title} ${content.category} ${content.content}'
        .toLowerCase();
    if (text.contains('obat') || text.contains('pengobatan')) {
      return const [
        'Minum obat pada jam yang sama setiap hari sesuai jadwal yang diberikan.',
        'Gunakan pengingat harian atau minta keluarga membantu memantau jadwal.',
        'Catat efek samping seperti mual, gatal, atau perubahan warna urine.',
        'Hubungi tenaga kesehatan bila obat terlewat, muntah setelah minum obat, atau muncul keluhan berat.',
      ];
    }
    if (text.contains('cegah') ||
        text.contains('penularan') ||
        text.contains('masker')) {
      return const [
        'Gunakan masker saat batuk, pilek, atau berada dekat orang lain.',
        'Buka jendela agar pertukaran udara di rumah berjalan baik.',
        'Tutup mulut dan hidung saat batuk, lalu cuci tangan dengan sabun.',
        'Pisahkan alat makan sementara bila masih dalam fase menular sesuai arahan petugas kesehatan.',
      ];
    }
    if (text.contains('gejala') ||
        text.contains('batuk') ||
        text.contains('diagnosis')) {
      return const [
        'Amati durasi batuk, demam, keringat malam, berat badan, dan nafsu makan.',
        'Catat kapan keluhan mulai muncul dan apakah ada kontak dengan pasien TBC.',
        'Datang ke puskesmas atau rumah sakit untuk pemeriksaan dahak atau rontgen bila keluhan menetap.',
        'Jangan memulai obat sendiri tanpa pemeriksaan dan arahan tenaga kesehatan.',
      ];
    }
    return const [
      'Pahami poin utama materi dan catat bagian yang perlu ditanyakan.',
      'Sesuaikan penerapan materi dengan kondisi pasien dan arahan tenaga kesehatan.',
      'Pantau perubahan kondisi secara berkala di rumah.',
      'Segera konsultasi bila keluhan memburuk atau muncul tanda bahaya.',
    ];
  }

  Widget _stepsSection() {
    final steps = _contextualSteps();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tata Cara Penerapan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...steps.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(entry.value, style: const TextStyle(height: 1.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<List<String>> _contextualTableRows() {
    final text = '${content.title} ${content.category} ${content.content}'
        .toLowerCase();
    if (text.contains('obat') || text.contains('pengobatan')) {
      return const [
        ['Situasi', 'Tindakan Aman'],
        [
          'Lupa minum obat',
          'Minum sesuai arahan petugas; jangan menggandakan dosis tanpa konsultasi.',
        ],
        [
          'Mual ringan',
          'Minum obat setelah makan bila diizinkan dan catat keluhannya.',
        ],
        [
          'Keluhan berat',
          'Segera hubungi puskesmas, dokter, atau layanan darurat.',
        ],
      ];
    }
    if (text.contains('cegah') ||
        text.contains('penularan') ||
        text.contains('masker')) {
      return const [
        ['Area', 'Langkah Pencegahan'],
        ['Rumah', 'Pastikan ventilasi terbuka dan sinar matahari masuk.'],
        [
          'Saat batuk',
          'Pakai masker, tutup mulut, dan buang tisu di tempat tertutup.',
        ],
        [
          'Kontak erat',
          'Arahkan keluarga serumah untuk skrining bila disarankan petugas.',
        ],
      ];
    }
    if (text.contains('gejala') ||
        text.contains('batuk') ||
        text.contains('diagnosis')) {
      return const [
        ['Tanda yang Diamati', 'Kapan Perlu Periksa'],
        ['Batuk lama', 'Bila batuk berlangsung dua minggu atau lebih.'],
        ['Keringat malam', 'Bila terjadi berulang tanpa penyebab jelas.'],
        [
          'Berat badan turun',
          'Bila disertai lemas, demam, atau nafsu makan menurun.',
        ],
      ];
    }
    return const [
      ['Aspek', 'Panduan'],
      [
        'Pemahaman',
        'Baca materi, tandai poin penting, dan siapkan pertanyaan.',
      ],
      [
        'Penerapan',
        'Ikuti saran yang sesuai dengan kondisi dan instruksi tenaga kesehatan.',
      ],
      [
        'Evaluasi',
        'Pantau hasil penerapan dan konsultasikan bila tidak membaik.',
      ],
    ];
  }

  Widget _tableSection() {
    final rows = _contextualTableRows();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tabel Panduan Praktis',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2.4)},
          children: rows.asMap().entries.map((entry) {
            final isHeader = entry.key == 0;
            return TableRow(
              decoration: BoxDecoration(
                color: isHeader
                    ? AppTheme.primaryColor.withValues(alpha: 0.08)
                    : Colors.white,
              ),
              children: entry.value.map((cell) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    cell,
                    style: TextStyle(
                      height: 1.4,
                      fontWeight: isHeader
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = _paragraphs();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Edukasi',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Bagikan Edukasi',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _share(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                content.category.toUpperCase(),
                style: TextStyle(
                  color: Colors.teal.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 18),
            _professionalSummary(),
            const SizedBox(height: 24),
            const Text(
              'Materi Lengkap',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...paragraphs.map(
              (paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  paragraph,
                  style: const TextStyle(fontSize: 15, height: 1.65),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _stepsSection(),
            const SizedBox(height: 24),
            _tableSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
