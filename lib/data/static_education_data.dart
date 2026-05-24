import '../models/education.dart';

class StaticEducationData {
  static const _kemenkesTbc = 'https://tbindonesia.or.id/';
  static const _permenkesTb =
      'https://bphn.go.id/data/documents/16pmkes067.pdf';
  static const _strategiTb =
      'https://www.tbindonesia.or.id/wp-content/uploads/2021/06/NSP-TB-2020-2024-Ind_Final_-BAHASA.pdf';
  static const _whoTb = 'https://www.who.int/health-topics/tuberculosis';

  static final Map<String, List<EducationContent>> categoryContent = {
    'mengenal tbc': [
      EducationContent(
        id: '101',
        title: 'Apa Itu Tuberkulosis (TBC)?',
        category: 'Mengenal TBC',
        source: _kemenkesTbc,
        content:
            '''Tuberkulosis atau TBC adalah penyakit menular yang disebabkan oleh bakteri Mycobacterium tuberculosis. Penyakit ini paling sering menyerang paru-paru, tetapi juga dapat menyerang bagian tubuh lain.

TBC bukan penyakit keturunan dan bukan akibat kutukan. TBC dapat dicegah, ditemukan melalui pemeriksaan kesehatan, dan diobati dengan obat anti tuberkulosis sesuai arahan tenaga kesehatan.''',
      ),
      EducationContent(
        id: '102',
        title: 'Cara Penularan TBC',
        category: 'Mengenal TBC',
        source: _whoTb,
        content:
            '''TBC menyebar melalui udara ketika orang dengan TBC paru atau TBC saluran napas yang infeksius batuk, bersin, berbicara, atau mengeluarkan percikan dari saluran napas.

Orang lain dapat terinfeksi bila menghirup udara yang mengandung kuman TBC. TBC tidak menular melalui berjabat tangan, berbagi makanan, atau memakai alat makan yang sama.''',
      ),
      EducationContent(
        id: '103',
        title: 'TBC Laten dan TBC Aktif',
        category: 'Mengenal TBC',
        source: _whoTb,
        content:
            '''Seseorang dapat terinfeksi kuman TBC tanpa mengalami gejala. Kondisi ini sering disebut infeksi TBC laten. Pada kondisi laten, orang tersebut tidak sakit TBC aktif dan tidak menularkan TBC kepada orang lain.

TBC aktif terjadi ketika kuman berkembang dan menimbulkan gejala. Orang dengan TBC aktif perlu diperiksa dan diobati agar sembuh dan agar penularan dapat dihentikan.''',
      ),
    ],
    'gejala & deteksi': [
      EducationContent(
        id: '201',
        title: 'Gejala yang Perlu Diwaspadai',
        category: 'Gejala & Deteksi',
        source: _kemenkesTbc,
        content:
            '''Gejala TBC paru yang perlu diwaspadai antara lain batuk yang berlangsung lama, batuk berdahak atau batuk darah, demam, berkeringat pada malam hari, berat badan turun, nafsu makan berkurang, nyeri dada, dan tubuh terasa lemah.

Jika keluhan menetap atau ada riwayat kontak erat dengan pasien TBC, segera periksa ke puskesmas, klinik, atau rumah sakit untuk mendapatkan pemeriksaan yang tepat.''',
      ),
      EducationContent(
        id: '202',
        title: 'Pemeriksaan untuk Menemukan TBC',
        category: 'Gejala & Deteksi',
        source: _strategiTb,
        content:
            '''Pemeriksaan TBC dilakukan oleh tenaga kesehatan berdasarkan gejala, riwayat kontak, dan pemeriksaan penunjang. Pemeriksaan dapat mencakup pemeriksaan dahak, tes cepat molekuler, rontgen dada, atau pemeriksaan lain sesuai kondisi pasien.

Jangan mendiagnosis diri sendiri dan jangan memulai obat TBC tanpa pemeriksaan. Pengobatan TBC harus mengikuti hasil pemeriksaan dan arahan tenaga kesehatan.''',
      ),
      EducationContent(
        id: '203',
        title: 'Kontak Erat Perlu Skrining',
        category: 'Gejala & Deteksi',
        source: _strategiTb,
        content:
            '''Orang yang tinggal serumah atau sering berada dekat dengan pasien TBC termasuk kelompok yang perlu diperhatikan. Kontak erat dapat dianjurkan untuk menjalani skrining sesuai arahan petugas kesehatan.

Skrining membantu menemukan orang yang sakit TBC lebih awal dan membantu menentukan apakah seseorang memerlukan pemantauan atau terapi pencegahan.''',
      ),
    ],
    'pencegahan': [
      EducationContent(
        id: '301',
        title: 'Pencegahan Penularan TBC di Rumah',
        category: 'Pencegahan',
        source: _permenkesTb,
        content:
            '''Pencegahan TBC dilakukan dengan mengurangi risiko penularan dan memastikan pasien mendapat pengobatan yang tepat. Rumah perlu memiliki ventilasi baik, cahaya matahari yang cukup, dan kebiasaan hidup bersih.

Pasien yang sedang batuk perlu menerapkan etika batuk, memakai masker sesuai anjuran, dan tidak membuang dahak sembarangan. Keluarga sebaiknya mendukung pasien agar berobat teratur sampai selesai.''',
      ),
      EducationContent(
        id: '302',
        title: 'Periksa Lebih Awal Bila Ada Gejala',
        category: 'Pencegahan',
        source: _kemenkesTbc,
        content:
            '''Menemukan TBC lebih awal adalah bagian penting dari pencegahan. Semakin cepat pasien diperiksa dan diobati sesuai standar, semakin besar peluang sembuh dan semakin kecil risiko menularkan kepada orang lain.

Jangan menunda pemeriksaan bila mengalami batuk lama atau gejala lain yang mengarah ke TBC, terutama bila ada kontak dengan pasien TBC.''',
      ),
      EducationContent(
        id: '303',
        title: 'Terapi Pencegahan TBC',
        category: 'Pencegahan',
        source: _strategiTb,
        content:
            '''Terapi Pencegahan Tuberkulosis atau TPT dapat diberikan kepada kelompok tertentu yang berisiko, sesuai hasil penilaian tenaga kesehatan. Tujuannya adalah menurunkan risiko berkembangnya penyakit TBC aktif.

TPT tidak boleh dimulai sendiri. Pemeriksaan dan keputusan pemberian TPT harus dilakukan oleh fasilitas pelayanan kesehatan.''',
      ),
    ],
    'etika batuk': [
      EducationContent(
        id: '401',
        title: 'Etika Batuk yang Benar',
        category: 'Etika Batuk',
        source: _permenkesTb,
        content:
            '''Etika batuk membantu mengurangi penyebaran percikan dari saluran napas. Saat batuk atau bersin, tutup hidung dan mulut menggunakan tisu, sapu tangan, atau lengan bagian dalam.

Buang tisu bekas ke tempat sampah dan bersihkan tangan setelah batuk atau bersin. Gunakan masker bila sedang batuk atau berada dekat orang lain sesuai anjuran kesehatan.''',
      ),
      EducationContent(
        id: '402',
        title: 'Jangan Meludah Sembarangan',
        category: 'Etika Batuk',
        source: _permenkesTb,
        content:
            '''Dahak pasien TBC dapat mengandung kuman. Karena itu, dahak tidak boleh dibuang sembarangan di tempat umum atau lingkungan rumah.

Bila perlu membuang dahak, ikuti arahan tenaga kesehatan atau gunakan tempat yang aman dan tertutup. Kebiasaan ini membantu menjaga lingkungan dan melindungi orang sekitar.''',
      ),
      EducationContent(
        id: '403',
        title: 'Cuci Tangan Setelah Batuk atau Bersin',
        category: 'Etika Batuk',
        source: _permenkesTb,
        content:
            '''Setelah batuk, bersin, membuang tisu, atau menyentuh masker, bersihkan tangan dengan sabun dan air mengalir. Jika tidak tersedia, gunakan pembersih tangan berbasis alkohol.

Kebiasaan membersihkan tangan membantu mengurangi penyebaran kuman melalui benda yang sering disentuh bersama.''',
      ),
    ],
    'obat-obatan oat': [
      EducationContent(
        id: '501',
        title: 'Pengobatan TBC dengan OAT',
        category: 'Obat-obatan OAT',
        source: _strategiTb,
        content:
            '''TBC dapat diobati dengan Obat Anti Tuberkulosis atau OAT. Obat harus diminum sesuai jenis, dosis, jadwal, dan lama pengobatan yang ditentukan oleh tenaga kesehatan.

Pasien tidak boleh menghentikan obat sendiri walaupun gejala sudah membaik. Pengobatan yang tidak teratur dapat menyebabkan penyakit tidak sembuh dan meningkatkan risiko TBC resistan obat.''',
      ),
      EducationContent(
        id: '502',
        title: 'Pentingnya Minum Obat Sampai Tuntas',
        category: 'Obat-obatan OAT',
        source: _strategiTb,
        content:
            '''Kepatuhan minum obat adalah kunci keberhasilan pengobatan TBC. Buat pengingat harian, minum obat pada waktu yang dianjurkan, dan libatkan keluarga atau pengawas minum obat bila diperlukan.

Jika lupa minum obat, muntah setelah minum obat, atau mengalami keluhan setelah minum obat, segera hubungi tenaga kesehatan untuk mendapatkan arahan.''',
      ),
      EducationContent(
        id: '503',
        title: 'Efek Samping Perlu Dilaporkan',
        category: 'Obat-obatan OAT',
        source: _strategiTb,
        content:
            '''Sebagian pasien dapat mengalami keluhan selama minum OAT. Keluhan ringan maupun berat sebaiknya disampaikan kepada tenaga kesehatan agar dapat dinilai dan ditangani dengan benar.

Jangan menghentikan atau mengganti obat sendiri. Tenaga kesehatan akan menentukan langkah yang aman sesuai kondisi pasien.''',
      ),
    ],
    'nutrisi': [
      EducationContent(
        id: '601',
        title: 'Gizi Seimbang Selama Pengobatan TBC',
        category: 'Nutrisi',
        source: _kemenkesTbc,
        content:
            '''Asupan gizi yang cukup membantu tubuh menjalani proses pemulihan selama pengobatan TBC. Konsumsi makanan beragam dengan sumber karbohidrat, lauk berprotein, sayur, buah, dan cairan yang cukup sesuai kebutuhan.

Nutrisi bukan pengganti OAT. Obat tetap harus diminum sesuai arahan tenaga kesehatan sampai pengobatan selesai.''',
      ),
      EducationContent(
        id: '602',
        title: 'Dukungan Keluarga untuk Makan dan Minum Obat',
        category: 'Nutrisi',
        source: _kemenkesTbc,
        content:
            '''Keluarga dapat membantu pasien dengan menyediakan makanan bergizi, mengingatkan jadwal minum obat, dan mendampingi kontrol ke fasilitas kesehatan.

Jika pasien sulit makan, berat badan menurun, atau memiliki penyakit lain seperti diabetes, konsultasikan pola makan dengan tenaga kesehatan.''',
      ),
    ],
  };
}
