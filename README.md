# 🩺 Aura Health

**Aura Health** adalah sebuah aplikasi *mobile* kesehatan yang berfokus pada penyakit TBC (Tuberkulosis). Aplikasi ini dirancang untuk membantu pengguna mendapatkan edukasi yang tepat, mengetahui alur deteksi, berbagi cerita di komunitas, serta berinteraksi dengan Chatbot AI.

> Aplikasi ini dibangun menggunakan **Flutter** sebagai pemenuhan tugas mata kuliah **Workshop Pemrograman Perangkat Bergerak**.

---

## 👥 Tim Pengembang (Kelompok)
Aplikasi ini dikembangkan oleh:
1. **Erick Haidar** - *Front-End Developer*
2. **Fajar** - *Backend Developer*
3. **Rizki** - *Backend Developer*

---

## ✨ Fitur Aplikasi (Front-End)
Saat ini struktur *Front-End* sudah selesai dibuat dengan fitur dan antarmuka sebagai berikut:

* **Autentikasi:** Splash Screen, Login, Register, dan Verifikasi OTP.
* **Dashboard Utama:** Beranda dengan ringkasan layanan, sapaan pengguna, dan list artikel terbaru.
* **Edukasi TBC:** Kategori pembelajaran TBC (Mengenal TBC, Gejala, Pencegahan, Obat OAT) serta halaman Detail Artikel.
* **Alur Deteksi:** Layar informasi faskes (Puskesmas/Klinik) terdekat dan langkah-langkah deteksi mandiri hingga pengobatan.
* **Komunitas:** Forum bagi pengguna untuk membagikan pengalaman pengobatan, saling mendukung, dan mempublikasikan postingan baru.
* **Chatbot AI:** Layar asisten AI cerdas untuk bertanya seputar TBC dengan fitur balon chat (*chat bubbles*) dan rekomendasi pertanyaan.
* **Profil & Pengaturan:** Manajemen akun, ubah detail profil (seperti ganti nama), dan pengaturan sistem (contoh: *Dark Mode*, Notifikasi).

---

## 🛠 Teknologi yang Digunakan
* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Tipografi / Font:** `google_fonts` (Menggunakan font *Inter*)
* **Ikonografi:** Bawaan Material Design & `font_awesome_flutter`

---

## 🚀 Cara Menjalankan Aplikasi
Ikuti langkah-langkah berikut untuk menjalankan aplikasi di komputer lokal:

### Prasyarat
Pastikan Anda sudah menginstal:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) versi terbaru.
* Android Studio (untuk Emulator) atau VS Code dengan ekstensi Flutter.

### Langkah-langkah
1.  **Buka Proyek:** Buka folder `aurahealth` di VS Code atau Android Studio Anda.
2.  **Unduh Dependensi (Library):** Buka terminal di dalam VS Code (tekan `` Ctrl + ` ``), lalu jalankan:
    ```bash
    flutter pub get
    ```

### Menjalankan Ngrok & Koneksi ke Backend
Karena aplikasi mobile memerlukan IP publik/Ngrok untuk menembak API lokal di laptop, ikuti panduan ini setiap kali memulai kerja (agar tidak lupa):
1. **Jalankan Backend:** Pastikan backend Node.js/Laravel Anda sudah jalan di port `3000` (atau port lain sesuai backend Anda).
2. **Jalankan Ngrok via VS Code Task:**
   - Tekan tombol `Ctrl + Shift + P` di VS Code.
   - Ketik dan pilih **Tasks: Run Task**.
   - Pilih **Run Ngrok (Port 3000)**.
   *(Ini otomatis akan membuka tab terminal baru berisi ngrok seperti di screenshot project lama Anda).*
3. **Update URL di Flutter:**
   - Copy URL `Forwarding` dari terminal Ngrok (contoh: `https://abcd-123.ngrok-free.dev`).
   - Buka file `lib/services/api_config.dart`.
   - Paste URL tersebut ke variabel `_ngrokUrl`.
   ```dart
   static const _ngrokUrl = 'https://url-ngrok-baru-kamu.ngrok-free.dev';
   ```

3.  **Jalankan Aplikasi:** Pastikan Emulator sudah menyala atau HP Anda sudah terhubung menggunakan kabel USB (*USB Debugging* aktif). Lalu jalankan:
    ```bash
    flutter run
    ```
    *Atau bisa juga dengan menekan tombol **F5** / **Run & Debug** di VS Code.*

---

## 📁 Struktur Folder Penting
Untuk modifikasi *source code* lebih lanjut, Anda bisa fokus ke folder berikut:
* `lib/theme.dart`: Berisi konfigurasi warna (dominan *Teal*), font, dan tema *widget* utama.
* `lib/main.dart`: Titik awal aplikasi (*entry point*) dan konfigurasi rute awal.
* `lib/screens/`: Folder tempat semua layar/antarmuka (UI) aplikasi disimpan.

---

*Semoga sukses dengan tugas matakuliahnya!* 🚀