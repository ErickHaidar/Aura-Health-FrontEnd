import '../models/education.dart';

class StaticEducationData {
  static final Map<String, List<EducationContent>> categoryContent = {
    'mengenal tbc': [
      EducationContent(
        id: 101,
        title: 'Memahami Mycobacterium tuberculosis sebagai Penyebab Utama',
        category: 'Mengenal TBC',
        content: '''Tuberkulosis (TBC) adalah penyakit infeksi menular yang disebabkan oleh bakteri Mycobacterium tuberculosis. Bakteri ini berbentuk batang dan bersifat tahan asam (BTA). 

TBC bukanlah penyakit keturunan, kutukan, atau guna-guna. Meskipun paling sering menyerang paru-paru (TBC Paru), bakteri ini dapat menyebar melalui aliran darah ke bagian tubuh lain (TBC Ekstra Paru), seperti kelenjar getah bening, tulang, selaput otak (meningitis TB), hingga kulit dan ginjal.''',
      ),
      EducationContent(
        id: 102,
        title: 'Droplet Nuclei: Bagaimana TBC Menyebar di Udara',
        category: 'Mengenal TBC',
        content: '''Penularan TBC terjadi melalui udara ketika penderita TBC paru aktif batuk, bersin, atau berbicara tanpa menutup mulut. Bakteri keluar dalam bentuk percikan dahak halus (droplet nuclei). 

Satu kali batuk dapat mengeluarkan sekitar 3.000 percikan yang mengandung kuman, sementara satu kali bersin dapat mengeluarkan hingga 1 juta kuman. Bakteri ini dapat bertahan lama melayang di udara, terutama di ruangan yang lembap, gelap, dan minim ventilasi, hingga akhirnya terhirup oleh orang lain.''',
      ),
      EducationContent(
        id: 103,
        title: 'Mengenal "Bakteri Tidur": Perbedaan TBC Laten dan TBC Aktif',
        category: 'Mengenal TBC',
        content: '''Seseorang dapat terinfeksi bakteri TBC namun tidak merasa sakit; kondisi ini disebut Infeksi Laten Tuberkulosis (ILTB). Pada ILTB, sistem kekebalan tubuh mampu mengendalikan bakteri sehingga bakteri tetap hidup dalam keadaan "tidur" (dormant). 

Orang dengan ILTB tidak memiliki gejala dan tidak dapat menularkan penyakit kepada orang lain. Sebaliknya, pada TBC Aktif, sistem imun gagal menahan bakteri sehingga bakteri berkembang biak, menimbulkan kerusakan jaringan, memicu gejala klinis, dan dapat menularkan kuman ke lingkungan sekitar.''',
      ),
      EducationContent(
        id: 104,
        title: 'Kerentanan Imun dan Jendela Inkubasi Bakteri',
        category: 'Mengenal TBC',
        content: '''Masa inkubasi TBC (dari paparan hingga muncul gejala) relatif panjang, yaitu sekitar 10 hingga 12 minggu. Seseorang lebih berisiko terkena TBC jika memiliki daya tahan tubuh yang rendah, seperti penderita HIV/AIDS (ODHIV), penderita Diabetes Melitus, perokok, lansia, dan anak-anak di bawah 5 tahun. 

Lingkungan tempat tinggal yang padat dan sanitasi udara yang buruk mempercepat sirkulasi bakteri di antara kontak erat pasien.''',
      ),
      EducationContent(
        id: 105,
        title: 'Tamu Tak Diundang: Perbedaan TBC Laten vs TBC Aktif',
        category: 'Mengenal TBC',
        content: '''Tahukah Anda bahwa Anda bisa memiliki bakteri TBC di dalam tubuh tanpa merasa sakit atau menularkannya? Kondisi ini disebut "TBC Laten". Ibarat bibit yang sedang menunggu waktu untuk tumbuh. Mengobatinya sekarang adalah "tindakan pencegahan" yang menjaga agar "tamu tak diundang" ini tidak pernah berubah menjadi penyakit TBC aktif.
        
Sumber: NHS - Latent TB Information''',
      ),
    ],
    'gejala & deteksi': [
      EducationContent(
        id: 201,
        title: 'Gejala Utama dan Gejala Penyerta TBC Paru',
        category: 'Gejala & Deteksi',
        content: '''Gejala utama TBC adalah batuk terus-menerus selama 2 minggu atau lebih, baik berdahak maupun tidak, yang terkadang disertai batuk darah. 

Gejala penyerta meliputi demam meriang yang berlangsung lama, keringat berlebih di malam hari meskipun tanpa aktivitas fisik, penurunan nafsu makan, dan penurunan berat badan secara drastis tanpa sebab yang jelas. Nyeri dada dan sesak napas biasanya muncul jika infeksi telah menyebabkan kerusakan luas pada jaringan paru.''',
      ),
      EducationContent(
        id: 202,
        title: 'Mengenali Tanda-tanda TBC pada Kelompok Anak',
        category: 'Gejala & Deteksi',
        content: '''TBC pada anak seringkali tidak menunjukkan gejala batuk yang khas seperti dewasa. Gejala yang perlu diwaspadai adalah berat badan anak yang tidak naik atau justru turun dalam 2 bulan terakhir (meskipun sudah diberi asupan gizi yang cukup), demam lama yang tidak diketahui penyebabnya, kelesuan (anak tidak aktif bermain), dan adanya kontak erat dengan penderita TBC dewasa. 

Diagnosis pada anak biasanya menggunakan sistem skoring berdasarkan parameter klinis dan hasil uji penunjang.''',
      ),
      EducationContent(
        id: 203,
        title: 'Keunggulan Tes Cepat Molekuler (TCM) dalam Deteksi Dini',
        category: 'Gejala & Deteksi',
        content: '''Tes Cepat Molekuler (TCM) saat ini merupakan alat diagnosis utama TBC di Indonesia sesuai standar WHO. TCM bekerja dengan mendeteksi DNA bakteri Mycobacterium tuberculosis pada sampel dahak pasien. 

Keunggulan TCM adalah waktu pengerjaan yang singkat (kurang dari 2 jam), tingkat akurasi yang tinggi, dan kemampuannya untuk mendeteksi apakah kuman tersebut sudah kebal (resisten) terhadap antibiotik Rifampisin (TBC RO).''',
      ),
      EducationContent(
        id: 204,
        title: 'Peran Mikroskopis BTA dan Radiologi dalam Diagnosis',
        category: 'Gejala & Deteksi',
        content: '''Jika TCM tidak tersedia, pemeriksaan dahak secara mikroskopis (BTA) dilakukan untuk melihat langsung bakteri pada slide. Sampel diambil secara SS (Sewaktu-Sewaktu) atau SP (Sewaktu-Pagi). 

Selain itu, foto Rontgen Dada (Thorax) digunakan sebagai pemeriksaan penunjang untuk melihat adanya kerusakan jaringan paru (infiltrat atau kavitas). Rontgen sangat penting terutama jika hasil pemeriksaan dahak negatif namun gejala klinis sangat mendukung ke arah TBC.''',
      ),
      EducationContent(
        id: 205,
        title: 'Mendeteksi Bakteri Tersembunyi dengan Uji Imunologi',
        category: 'Gejala & Deteksi',
        content: '''Untuk mendeteksi apakah seseorang pernah terpapar kuman TBC (infeksi laten), digunakan Uji Tuberkulin (Tes Mantoux) atau tes darah IGRA (Interferon-Gamma Release Assay). 

Pada tes Mantoux, sedikit cairan tuberkulin disuntikkan di bawah kulit lengan dan hasilnya dibaca setelah 48-72 jam berdasarkan benjolan yang terbentuk. Tes ini sangat krusial dalam mendiagnosis TBC pada anak-anak dan untuk menentukan pemberian Terapi Pencegahan Tuberkulosis (TPT).''',
      ),
      EducationContent(
        id: 206,
        title: 'Aturan 3-Minggu: Mengenali Tanda-tanda TBC',
        category: 'Gejala & Deteksi',
        content: '''Batuk terus-menerus yang berlangsung lebih dari 3 minggu adalah tanda peringatan paling umum dari TBC. Waspadai juga "tanda bahaya" lainnya seperti keringat malam, demam, dan penurunan berat badan yang tidak dapat dijelaskan. Jika Anda atau orang yang Anda cintai mengalami gejala-gejala ini, pemeriksaan sederhana dapat memberikan kepastian dan ketenangan pikiran.
        
Sumber: CDC - TB Signs and Symptoms''',
      ),
    ],
    'pencegahan': [
      EducationContent(
        id: 301,
        title: 'Vaksinasi BCG: Tameng Awal Si Kecil dari TBC Berat',
        category: 'Pencegahan',
        content: '''Vaksin Bacillus Calmette-Guérin (BCG) adalah imunisasi wajib di Indonesia yang bertujuan memberikan perlindungan terhadap infeksi bakteri Mycobacterium tuberculosis. 

Vaksin ini sangat krusial diberikan kepada bayi sebelum usia 1 bulan (paling lambat sebelum 2 bulan). Meski tidak mencegah infeksi TBC secara total pada orang dewasa, BCG sangat efektif dalam mencegah bentuk TBC yang berat dan mematikan pada anak-anak, seperti TBC Milier dan Meningitis TBC (radang selaput otak).''',
      ),
      EducationContent(
        id: 302,
        title: 'Terapi Pencegahan TBC (TPT): Memutus Rantai Infeksi Laten',
        category: 'Pencegahan',
        content: '''Tidak semua orang yang menghirup bakteri TBC langsung jatuh sakit. Banyak yang berada dalam kondisi Infeksi Laten TBC (ILTB), di mana bakteri ada di tubuh namun "tidur". 

TPT adalah pemberian obat untuk kelompok berisiko tinggi (seperti orang yang tinggal serumah dengan pasien TBC, orang dengan HIV/AIDS, atau anak di bawah 5 tahun) agar bakteri tersebut tidak aktif dan menjadi penyakit TBC di kemudian hari. TPT terbukti efektif menurunkan risiko berkembangnya TBC aktif hingga 90%.''',
      ),
      EducationContent(
        id: 303,
        title: 'Rumah Sehat Tanpa TBC: Peran Penting Ventilasi dan Cahaya Matahari',
        category: 'Pencegahan',
        content: '''Bakteri TBC adalah organisme yang sangat sensitif terhadap sinar ultraviolet (UV). Di ruangan yang gelap, lembap, dan tertutup, bakteri ini dapat bertahan hidup di udara selama berjam-jam. 

Langkah pencegahan lingkungan yang paling efektif adalah memastikan ventilasi rumah berjalan baik dengan membuka jendela setiap pagi agar terjadi pertukaran udara (sirkulasi) dan membiarkan sinar matahari masuk ke dalam kamar. Ruangan yang kering dan terang adalah musuh alami bakteri TBC.''',
      ),
      EducationContent(
        id: 304,
        title: 'Mengenal Strategi TOSS TB untuk Eliminasi TBC',
        category: 'Pencegahan',
        content: '''Pencegahan penularan terbaik adalah dengan menemukan pasien TBC sedini mungkin dan memastikannya minum obat hingga tuntas. Setelah 2 minggu menjalani pengobatan yang tepat, jumlah kuman dalam tubuh pasien berkurang drastis sehingga risiko menularkan ke orang lain menurun secara signifikan. 

TOSS TB mengajak masyarakat untuk tidak memberikan stigma, melainkan mendukung pasien agar patuh minum obat minimal selama 6 bulan tanpa putus.''',
      ),
      EducationContent(
        id: 305,
        title: 'Memutus Rantai Penularan: Langkah Sederhana Tetap Aman',
        category: 'Pencegahan',
        content: '''TBC menyebar melalui udara saat seseorang batuk atau berbicara, tetapi penyakit ini lebih sulit ditularkan daripada flu. Anda tidak bisa tertular dari jabat tangan atau berbagi makanan! Pertahanan terbaik adalah udara segar (ventilasi yang baik), menutup mulut dengan tisu saat batuk atau tertawa, dan pemeriksaan dini bagi mereka yang melakukan kontak erat.
        
Sumber: Johns Hopkins - TB Prevention & Spread''',
      ),
    ],
    'etika batuk': [
      EducationContent(
        id: 401,
        title: 'Memahami Bahaya Droplet: Mengapa Etika Batuk Itu Wajib?',
        category: 'Etika Batuk',
        content: '''Bakteri TBC menyebar melalui udara melalui droplet nuclei (percikan dahak yang sangat kecil) yang keluar saat penderita batuk, bersin, bicara, atau meludah. 

Tanpa etika yang benar, satu kali batuk dapat menyebarkan hingga 3.000 percikan yang mengandung kuman ke udara sekitar. Menerapkan etika batuk adalah bentuk tanggung jawab sosial untuk melindungi keluarga dan orang lain dari tertular penyakit yang menyerang paru-paru ini.''',
      ),
      EducationContent(
        id: 402,
        title: '5 Langkah Praktis Etika Batuk Menurut Standar Kesehatan',
        category: 'Etika Batuk',
        content: '''1. Gunakan Masker: Segera pakai masker medis jika Anda merasa sedang batuk atau flu.
2. Tutup dengan Tisu: Gunakan tisu atau sapu tangan untuk menutup hidung dan mulut saat batuk/bersin.
3. Gunakan Siku Dalam: Jika tidak ada tisu, gunakan lengan atas bagian dalam (siku dalam) untuk menutup, bukan telapak tangan.
4. Buang Segera: Masukkan tisu bekas ke tempat sampah yang tertutup.
5. Cuci Tangan: Bersihkan tangan dengan air mengalir dan sabun atau cairan pembersih tangan berbasis alkohol.''',
      ),
      EducationContent(
        id: 403,
        title: 'Stop Menutup Batuk dengan Telapak Tangan! Ini Alasannya',
        category: 'Etika Batuk',
        content: '''Banyak orang secara refleks menutup mulut dengan telapak tangan saat batuk. Ini adalah kesalahan besar dalam pencegahan TBC. Bakteri akan menempel pada telapak tangan dan dapat bertahan hidup cukup lama. 

Saat Anda menyentuh pegangan pintu, berjabat tangan, atau memegang fasilitas umum, bakteri tersebut berpindah dan akan terhirup oleh orang lain yang menyentuh benda yang sama. Gunakanlah lengan atas bagian dalam sebagai gantinya karena area tersebut jarang bersentuhan dengan objek lain.''',
      ),
      EducationContent(
        id: 404,
        title: 'Etika Membuang Dahak: Jangan Meludah di Sembarang Tempat',
        category: 'Etika Batuk',
        content: '''Dahak penderita TBC mengandung konsentrasi bakteri yang sangat tinggi. Meludah sembarangan di jalan atau di tempat terbuka memungkinkan dahak mengering, terbawa angin, dan bakterinya terhirup oleh orang sehat. 

Jika perlu membuang dahak, lakukanlah di kamar mandi/WC dan segera siram hingga bersih, atau gunakan wadah tertutup yang telah dicampur disinfektan/cairan pembersih.''',
      ),
      EducationContent(
        id: 405,
        title: 'Cuci Tangan: Langkah Terakhir yang Tak Boleh Terlewatkan',
        category: 'Etika Batuk',
        content: '''Setelah melakukan etika batuk, tangan harus segera didekontaminasi. Kuman yang mungkin tidak sengaja menempel di jari saat membuang tisu harus dihilangkan sebelum Anda menyentuh wajah (hidung/mulut) atau benda lain. 

Gunakan sabun dan air mengalir minimal selama 20 detik untuk memastikan bakteri benar-benar luruh dari kulit tangan.''',
      ),
    ],
    'obat-obatan oat': [
      EducationContent(
        id: 501,
        title: 'Mengenal Jenis Obat Anti Tuberkulosis (OAT)',
        category: 'Obat-obatan OAT',
        content: '''Pengobatan TBC menggunakan kombinasi beberapa jenis antibiotik khusus yang disebut OAT. Untuk pasien baru, biasanya digunakan kombinasi 4 jenis obat utama (Lini Pertama):

- Rifampisin (R): Membunuh kuman yang aktif membelah.
- Isoniazid (H): Antibiotik paling kuat untuk membunuh bakteri TBC.
- Pirazinamid (Z): Membunuh kuman yang berada di dalam sel tubuh.
- Etambutol (E): Mencegah kuman menjadi kebal terhadap obat lain.

Obat ini biasanya tersedia dalam bentuk KDT (Kombinasi Dosis Tetap) atau satu tablet yang berisi campuran keempat obat tersebut agar lebih praktis diminum.''',
      ),
      EducationContent(
        id: 502,
        title: 'Dua Fase Pengobatan: Tahap Intensif & Lanjutan',
        category: 'Obat-obatan OAT',
        content: '''Pengobatan TBC tidak boleh berhenti meskipun tubuh sudah terasa sehat. Ada dua fase penting:

- Fase Intensif (2 Bulan Pertama): Pasien minum obat setiap hari. Tujuannya untuk membunuh sebagian besar kuman dengan cepat sehingga pasien tidak lagi menularkan penyakit ke orang lain.
- Fase Lanjutan (4-6 Bulan Berikutnya): Obat diminum setiap hari atau 3 kali seminggu (tergantung regimen dokter). Tujuannya untuk membunuh sisa-sisa kuman yang "tidur" agar penyakit tidak kambuh kembali.

Total waktu pengobatan standar adalah 6 bulan tanpa putus.''',
      ),
      EducationContent(
        id: 503,
        title: 'Pentingnya Kepatuhan & Bahaya TB Resisten Obat (TB-RO)',
        category: 'Obat-obatan OAT',
        content: '''Kepatuhan adalah kunci kesembuhan. Jika pasien sering lupa atau sengaja menghentikan obat sebelum waktunya, kuman TBC akan bermutasi dan menjadi kebal terhadap obat biasa. Kondisi ini disebut TB Resisten Obat (TB-RO).

- Bahayanya: TB-RO lebih sulit disembuhkan, memerlukan waktu pengobatan lebih lama (9-24 bulan), jenis obat yang lebih banyak, dan efek samping yang lebih berat.
- Saran Praktis: Gunakan alarm di ponsel dan tunjuk seorang PMO (Pengawas Minum Obat) dari anggota keluarga untuk mengingatkan Anda setiap hari.''',
      ),
      EducationContent(
        id: 504,
        title: 'Mengenali dan Mengatasi Efek Samping OAT',
        category: 'Obat-obatan OAT',
        content: '''Efek samping obat adalah hal yang umum, namun sebagian besar bersifat ringan:

- Urine Berwarna Oranye/Merah: Disebabkan oleh Rifampisin. Ini normal dan tidak berbahaya.
- Mual & Nyeri Perut: Minum obat sebelum tidur atau 1 jam setelah makan sedikit makanan untuk mengurangi rasa mual.
- Kesemutan/Kebas: Biasanya diatasi dengan tambahan Vitamin B6 (Piridoksin).
- Nyeri Sendi: Dapat dibantu dengan kompres hangat atau obat pereda nyeri sesuai anjuran dokter.
- Waspada (Segera ke Dokter): Jika mengalami mata kuning, gatal-gatal hebat (ruam kulit), gangguan penglihatan, atau gangguan pendengaran.''',
      ),
      EducationContent(
        id: 505,
        title: 'Tips Praktis Cara Minum Obat yang Benar',
        category: 'Obat-obatan OAT',
        content: '''- Waktu yang Sama: Minumlah obat di jam yang sama setiap hari agar kadar obat dalam darah tetap stabil.
- Perut Kosong vs Isi: Rifampisin dan Isoniazid paling baik diserap saat perut kosong (1 jam sebelum atau 2 jam sesudah makan). Namun, jika mual hebat, konsultasikan untuk diminum bersama sedikit makanan.
- Jangan Dopelek: Jika lupa satu dosis, segera minum saat ingat. Namun jika sudah mendekati jam dosis berikutnya, jangan minum dua dosis sekaligus.''',
      ),
      EducationContent(
        id: 506,
        title: 'Menyelesaikan Pengobatan: Mengapa Setiap Dosis Sangat Berarti',
        category: 'Obat-obatan OAT',
        content: '''Pengobatan TBC adalah perlombaan lari maraton, bukan lari cepat, biasanya berlangsung 6 hingga 9 bulan. Meskipun Anda merasa 100% lebih baik hanya dalam beberapa minggu, bakteri mungkin masih "tertidur" di dalam tubuh Anda. Menghabiskan setiap dosis memastikan bakteri benar-benar hilang dan mencegah munculnya "kuman super" yang kebal obat.
        
Sumber: WHO - Tuberculosis Treatment Q&A''',
      ),
    ],
    'nutrisi tbc': [
      EducationContent(
        id: 601,
        title: 'Prinsip Diet TKTP: Kunci Pemulihan Tubuh',
        category: 'Nutrisi TBC',
        content: '''Pasien TBC membutuhkan energi lebih banyak karena tubuh sedang berperang melawan infeksi. Kemenkes merekomendasikan diet TKTP (Tinggi Kalori Tinggi Protein):

- Energi Tinggi: Dibutuhkan 35-45 kkal per kg berat badan setiap hari untuk mengembalikan berat badan yang hilang.
- Protein Tinggi: Dibutuhkan 1,2-2,5 gram per kg berat badan untuk memperbaiki jaringan paru yang rusak.
- Pola Makan: Makanlah dengan porsi kecil tapi sering (misal: 3 kali makan besar dan 2-3 kali selingan/camilan sehat) untuk mengatasi rasa mual.''',
      ),
      EducationContent(
        id: 602,
        title: 'Protein Hewani untuk Meningkatkan Sel Imun',
        category: 'Nutrisi TBC',
        content: '''Protein hewani mengandung asam amino lengkap yang membantu pembentukan antibodi dan sel limfosit untuk melawan bakteri TBC.

- Pilihan Terbaik: Telur (terutama putih telur), ikan (ikan kembung, salmon, tuna), daging ayam tanpa kulit, daging sapi rendah lemak, serta susu.
- Target: Usahakan ada minimal satu porsi protein hewani di setiap jam makan utama. Protein hewani lebih mudah diserap oleh tubuh penderita TBC dibandingkan protein nabati.''',
      ),
      EducationContent(
        id: 603,
        title: 'Vitamin dan Mineral Esensial (Mikronutrisi)',
        category: 'Nutrisi TBC',
        content: '''Mikronutrisi sangat penting untuk mempercepat pemulihan fungsi paru:

- Vitamin A & D: Menjaga kekebalan tubuh. Sumber: Wortel, hati ayam, telur, dan minyak ikan. Sinar matahari pagi juga membantu pembentukan Vitamin D.
- Vitamin C & E: Sebagai antioksidan pelindung sel. Sumber: Jeruk, jambu biji, broccoli, dan alpukat.
- Seng (Zinc) & Zat Besi (Fe): Membantu mengatasi anemia dan meningkatkan imunitas. Sumber: Daging merah, bayam, kacang-kacangan, dan kerang.''',
      ),
      EducationContent(
        id: 604,
        title: 'Mengatasi Mual dan Menjaga Nafsu Makan',
        category: 'Nutrisi TBC',
        content: '''Mual adalah keluhan paling sering akibat efek samping obat atau penyakit itu sendiri.

- Saran Praktis: Hindari makanan yang berbau terlalu tajam atau terlalu berminyak/digoreng saat sedang mual. Pilihlah makanan yang lunak dan mudah dicerna.
- Minuman Hangat: Jahe hangat dapat membantu meredakan rasa mual sebelum makan.
- Cukup Cairan: Minum minimal 2 liter (8-10 gelas) air putih sehari untuk menjaga hidrasi dan membantu mengencerkan dahak.''',
      ),
      EducationContent(
        id: 605,
        title: 'Batasan dan Pantangan Selama Pengobatan',
        category: 'Nutrisi TBC',
        content: '''Meskipun tidak ada pantangan mutlak, beberapa hal perlu dibatasi agar pengobatan maksimal:

- Kurangi Kafein & Teh: Kandungan tanin dalam teh dan kafein dalam kopi dapat menghambat penyerapan zat besi dan beberapa jenis obat. Sebaiknya tidak diminum bersamaan dengan waktu minum obat.
- Hindari Rokok & Alkohol: Rokok memperparah kerusakan paru, sedangkan alkohol dapat meningkatkan risiko kerusakan hati (hepatotoksik) saat dikombinasikan dengan OAT.
- Batasi Lemak Berlebih: Makanan yang terlalu berlemak dapat memperberat rasa mual dan mengiritasi tenggorokan (memicu batuk).''',
      ),
      EducationContent(
        id: 606,
        title: 'Menambah Tenaga: Makanan untuk Tubuh yang Lebih Kuat',
        category: 'Nutrisi TBC',
        content: '''Sistem kekebalan tubuh adalah tentara pribadi tubuh Anda. Untuk membantunya melawan TBC, fokuslah pada "makanan bertenaga" seperti telur, kacang-kacangan, dan daging untuk protein, ditambah buah dan sayuran berwarna-warni. Menghindari tembakau dan alkohol memberi paru-paru dan hati Anda peluang terbaik untuk sembuh dengan cepat selama masa pengobatan.
        
Sumber: Cleveland Clinic - TB Management & Lifestyle''',
      ),
    ],
  };
}
