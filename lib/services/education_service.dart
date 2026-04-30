import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/education.dart';
import 'api_config.dart';

class EducationService {
  // ─── Kategori edukasi ───
  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/education/categories'),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : [];
        final categories = rawList.map((json) => EducationCategory.fromJson(json)).toList();
        return {'success': true, 'categories': categories};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat kategori'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Konten per kategori ───
  static Future<Map<String, dynamic>> getContentByCategory(String category) async {
    // ─── Static Fallback Content ───
    final lowerCategory = category.toLowerCase();
    if (lowerCategory == 'etika batuk') {
      return {
        'success': true,
        'contents': [
          EducationContent(
            id: 901,
            title: 'Mengapa Etika Batuk Penting?',
            category: 'Etika Batuk',
            content:
                'TBC menular melalui udara lewat percikan dahak (droplet). Satu kali batuk dapat menyebarkan hingga 3000 kuman. Tanpa etika yang benar, kuman ini melayang di udara dan berisiko terhirup orang lain.',
          ),
          EducationContent(
            id: 902,
            title: 'Langkah-langkah Etika Batuk yang Benar',
            category: 'Etika Batuk',
            content: '''1. Gunakan masker saat sakit.
2. Tutup mulut & hidung dengan lengan atas bagian dalam (siku) jika tidak ada tisu.
3. Tutup dengan tisu jika tersedia.
4. Segera buang tisu ke tempat sampah tertutup.
5. Cuci tangan dengan sabun/hand sanitizer.''',
          ),
          EducationContent(
            id: 903,
            title: 'Kebiasaan Salah yang Harus Dihindari',
            category: 'Etika Batuk',
            content:
                'Jangan menutup batuk dengan telapak tangan karena kuman akan menempel di tangan dan berpindah saat bersalaman. Jangan meludah sembarangan; ludahlah di wastafel/WC dan siram hingga bersih.',
          ),
        ]
      };
    }
    if (lowerCategory == 'mengenal tbc') {
      return {
        'success': true,
        'contents': [
          EducationContent(
            id: 801,
            title: 'Apa itu Penyakit TBC?',
            category: 'Mengenal TBC',
            content:
                'TBC (Tuberkulosis) adalah penyakit menular yang disebabkan oleh kuman Mycobacterium tuberculosis. Kuman ini masuk ke tubuh melalui pernapasan dan paling sering menyerang paru-paru (TB Paru), namun juga bisa menyerang organ lain seperti tulang, otak, dan kelenjar getah bening (TB Ekstra Paru).',
          ),
          EducationContent(
            id: 802,
            title: 'Bagaimana TBC Menular?',
            category: 'Mengenal TBC',
            content:
                'TBC menyebar melalui udara (airborne) melalui percikan dahak (droplet) saat penderita TBC aktif batuk, bersin, atau berbicara. TBC TIDAK menular melalui jabat tangan, berbagi alat makan, atau bersentuhan dengan pakaian penderita.',
          ),
          EducationContent(
            id: 803,
            title: 'TBC Laten vs TBC Aktif',
            category: 'Mengenal TBC',
            content:
                'TBC Laten adalah kondisi di mana bakteri ada di tubuh namun "tertidur" karena sistem imun kuat (tidak ada gejala & tidak menular). TBC Aktif adalah saat bakteri berkembang biak, menimbulkan gejala, dan bisa menularkan ke orang lain.',
          ),
        ]
      };
    }

    if (lowerCategory == 'gejala & deteksi') {
      return {
        'success': true,
        'contents': [
          EducationContent(
            id: 811,
            title: 'Gejala Utama yang Harus Diwaspadai',
            category: 'Gejala & Deteksi',
            content: 'Segera periksa jika Anda mengalami:\n'
                '- Batuk terus-menerus selama 2 minggu atau lebih.\n'
                '- Demam meriang yang berlangsung lama.\n'
                '- Berkeringat di malam hari meski tanpa aktivitas.\n'
                '- Penurunan berat badan dan nafsu makan secara drastis.',
          ),
          EducationContent(
            id: 812,
            title: 'Metode Diagnosis Medis',
            category: 'Gejala & Deteksi',
            content:
                'Diagnosis utama saat ini adalah Tes Cepat Molekuler (TCM) yang dapat mendeteksi kuman dan resistansi obat dalam 2 jam. Metode lain termasuk pemeriksaan dahak (BTA), Rontgen dada (Toraks), dan tes kulit Mantoux (terutama pada anak).',
          ),
          EducationContent(
            id: 813,
            title: 'Mengenal TBC pada Anak',
            category: 'Gejala & Deteksi',
            content:
                'Gejala pada anak seringkali tidak spesifik, seperti BB yang tidak naik dalam 2 bulan, anak lesu/tidak aktif bermain, dan demam berulang. Dokter biasanya menggunakan sistem skoring untuk mendiagnosis TBC pada anak.',
          ),
        ]
      };
    }

    if (lowerCategory == 'pencegahan') {
      return {
        'success': true,
        'contents': [
          EducationContent(
            id: 821,
            title: 'Vaksinasi BCG untuk Bayi',
            category: 'Pencegahan',
            content:
                'Vaksin BCG (Bacillus Calmette-Guérin) adalah imunisasi wajib yang diberikan pada bayi usia 0-2 bulan. Vaksin ini sangat efektif mencegah TBC berat pada anak, seperti meningitis TBC (radang selaput otak).',
          ),
          EducationContent(
            id: 822,
            title: 'Terapi Pencegahan TBC (TPT)',
            category: 'Pencegahan',
            content:
                'Jika Anda tinggal serumah dengan penderita TBC, Anda mungkin perlu mengonsumsi obat pencegahan (TPT) meskipun tidak merasa sakit. TPT bertujuan mematikan kuman laten agar tidak berkembang menjadi sakit TBC di masa depan.',
          ),
          EducationContent(
            id: 823,
            title: 'Ciptakan Lingkungan Rumah Sehat',
            category: 'Pencegahan',
            content:
                'Kuman TBC mudah mati jika terkena sinar matahari langsung dan sirkulasi udara yang baik. Pastikan rumah memiliki ventilasi yang cukup dan buka jendela setiap pagi agar udara segar masuk.',
          ),
        ]
      };
    }

    if (lowerCategory == 'obat-obatan oat') {
      return {
        'success': true,
        'contents': [
          EducationContent(
            id: 831,
            title: 'Mengenal Obat Anti Tuberkulosis (OAT)',
            category: 'Obat-obatan OAT',
            content:
                'Pengobatan TBC menggunakan kombinasi beberapa antibiotik khusus (OAT) seperti Rifampisin, Isoniazid, Pirazinamid, dan Etambutol. Obat ini biasanya dikemas dalam satu tablet (KDT/Kombinasi Dosis Tetap) agar lebih mudah dikonsumsi.',
          ),
          EducationContent(
            id: 832,
            title: 'Tahapan dan Durasi Pengobatan',
            category: 'Obat-obatan OAT',
            content: 'Pengobatan TBC berlangsung minimal 6 bulan tanpa putus, terbagi menjadi:\n'
                '- Fase Intensif (2 bulan): Mematikan kuman dengan cepat.\n'
                '- Fase Lanjutan (4 bulan): Membunuh sisa kuman agar tidak kambuh.\n'
                '- JANGAN BERHENTI minum obat meskipun sudah merasa sehat sebelum waktunya.',
          ),
          EducationContent(
            id: 833,
            title: 'Efek Samping dan Aturan Minum',
            category: 'Obat-obatan OAT',
            content:
                'Rifampisin & Isoniazid sebaiknya diminum saat perut kosong. Efek samping umum termasuk air seni berwarna merah (normal), mual, atau kesemutan. Segera hubungi petugas kesehatan jika muncul gejala berat seperti mata kuning atau gatal-gatal hebat.',
          ),
        ]
      };
    }


    if (lowerCategory == 'nutrisi tbc') {
      return {
        'success': true,
        'contents': [
          EducationContent(
            id: 911,
            title: 'Prinsip Gizi TKTP',
            category: 'Nutrisi TBC',
            content:
                'Pasien TBC membutuhkan diet Tinggi Kalori Tinggi Protein (TKTP) untuk melawan infeksi dan mencegah penurunan berat badan (malnutrisi). Konsumsilah 3-4 porsi protein hewani (daging, ikan, telur) dan nabati (tahu, tempe) setiap hari.',
          ),
          EducationContent(
            id: 912,
            title: 'Vitamin & Mineral Pendukung Imunitas',
            category: 'Nutrisi TBC',
            content:
                'Tingkatkan asupan Vitamin A, C, D, E serta mineral seperti Seng (Zinc) dan Selenium dari sayur dan buah berwarna cerah (wortel, bayam, jeruk, mangga). Mineral ini krusial untuk integritas sistem imun paru-paru.',
          ),
          EducationContent(
            id: 913,
            title: 'Pantangan Makanan & Minuman',
            category: 'Nutrisi TBC',
            content:
                'Hindari makanan berminyak (gorengan), lemak jenuh, dan makanan/minuman terlalu manis karena dapat memicu batuk dan mual. Batasi kafein (kopi/teh) dan alkohol karena dapat mengganggu penyerapan obat.',
          ),
        ]
      };
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/education/category/$category'),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : [];
        final contents = rawList.map((json) => EducationContent.fromJson(json)).toList();
        return {'success': true, 'contents': contents};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat konten'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Detail konten edukasi ───
  static Future<Map<String, dynamic>> getContentDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/education/$id'),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'content': EducationContent.fromJson(data['data']),
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Konten tidak ditemukan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }
}
