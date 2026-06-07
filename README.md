# 🩺 Aura Health: Platform Digital Edukasi dan Komunitas TBC (Frontend)

## Pendahuluan

Aura Health adalah aplikasi mobile berbasis Flutter yang dirancang untuk mendukung upaya edukasi dan penanggulangan penyakit Tuberkulosis (TBC). Platform ini menyediakan akses cepat terhadap informasi medis, panduan deteksi mandiri, serta ruang komunitas bagi pengguna untuk saling berbagi pengalaman.

Proyek ini dikembangkan untuk memenuhi tugas mata kuliah **Workshop Pemrograman Perangkat Bergerak**.

## Tim Pengembang

| Nama | Peran |
| :--- | :--- |
| **Erick Haidar** | Front-End Developer |
| **Fajar** | Front-End & Backend Developer |
| **Rizqi** | Backend Developer |

## Fitur Unggulan

Aplikasi ini mengintegrasikan berbagai modul penting untuk memberikan layanan kesehatan yang menyeluruh:

- **Sistem Autentikasi**: Mendukung pendaftaran dan masuk akun dengan verifikasi OTP untuk memastikan validitas data pengguna.
- **Dashboard Terintegrasi**: Halaman utama yang menampilkan ringkasan layanan, artikel kesehatan terbaru, dan sapaan personal.
- **Modul Edukasi**: Katalog informasi terstruktur mengenai gejala, metode pencegahan, hingga panduan konsumsi obat OAT.
- **Alur Deteksi & Faskes**: Informasi lokasi fasilitas kesehatan terdekat beserta langkah-langkah deteksi dini yang akurat.
- **Forum Komunitas**: Ruang interaksi bagi pengguna untuk berdiskusi, memberikan dukungan, dan mempublikasikan konten terkait pemulihan TBC.
- **Asisten AI (Aura Assistant)**: Chatbot cerdas yang mampu menjawab pertanyaan seputar TBC secara instan melalui antarmuka percakapan yang interaktif.
- **Pengaturan Akun & UI**: Personalisasi profil pengguna dan konfigurasi tampilan aplikasi termasuk dukungan Mode Gelap.

## Arsitektur Teknologi

| Komponen | Spesifikasi |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev/) |
| **Bahasa Pemrograman** | Dart |
| **State Management** | Provider |
| **Komunikasi API** | Http Client |
| **Penyimpanan Lokal** | Shared Preferences |
| **Tipografi** | Inter (via Google Fonts) |
| **Ikonografi** | Font Awesome & Material Icons |

## Instalasi dan Menjalankan Aplikasi

### Prasyarat

- **Flutter SDK**: Versi terbaru pada channel stable.
- **IDE**: Visual Studio Code atau Android Studio dengan ekstensi Flutter terpasang.
- **Emulator/Perangkat**: Android atau iOS dengan fitur USB Debugging aktif.
- **Backend**: Backend Aura Health berjalan dan dapat diakses oleh aplikasi.

### Langkah-langkah

1. Masuk ke direktori proyek:
   ```bash
   cd Aura-Health-FrontEnd
   ```

2. Instal semua dependensi yang diperlukan:
   ```bash
   flutter pub get
   ```

3. Konfigurasi Environment:
   Buat file `.env` di root folder frontend (jika belum ada) dan sesuaikan variabel `API_URL` dengan alamat server backend Anda.
   
   *Contoh isi file `.env`:*
   ```env
   API_URL=http://localhost:3000
   ```

   | Target | Contoh `API_URL` | Catatan |
   |---|---|---|
   | Flutter Web lokal | `http://localhost:3000` | Web dapat mengakses backend lokal melalui browser. |
   | Android Emulator | `http://10.0.2.2:3000` | `10.0.2.2` mengarah ke host machine dari emulator Android. |
   | Perangkat fisik | `http://192.168.1.10:3000` | Gunakan IP lokal komputer yang menjalankan backend. |
   | Tunnel publik | `https://nama-tunnel.ngrok-free.app` | Digunakan jika perangkat membutuhkan akses melalui internet (misal Ngrok). |

4. Jalankan aplikasi Flutter:
   ```bash
   flutter run
   ```
   
   Jika terdapat beberapa device, pilih target dengan melihat daftar device terlebih dahulu:
   ```bash
   flutter devices
   flutter run -d <device-id>
   ```

## Struktur Folder

| Path | Fungsi |
|---|---|
| `lib/main.dart` | Entry point aplikasi dan konfigurasi route utama. |
| `lib/theme.dart` | Konfigurasi tema utama aplikasi. |
| `lib/core/theme/` | Konfigurasi tema tambahan. |
| `lib/core/config/` | Konfigurasi API yang digunakan beberapa layar. |
| `lib/screens/` | Kumpulan halaman aplikasi berdasarkan modul. |
| `lib/services/` | Service untuk komunikasi API dan proses data eksternal. |
| `lib/models/` | Model data aplikasi. |
| `lib/providers/` | Provider untuk state management. |
| `lib/widgets/` | Widget reusable. |
| `lib/data/` | Data statis yang digunakan aplikasi. |
| `assets/images/` | Aset gambar aplikasi. |
| `test/` | Unit test dan widget test. |

## Integrasi Backend

Dokumentasi endpoint backend tersedia di `API_DOCS.md`. Secara umum, frontend menggunakan base URL dari `API_URL` dan menambahkan path `/api` melalui konfigurasi API.

| Area API | Endpoint Dasar | Kegunaan |
|---|---|---|
| Auth | `/api/auth` | Registrasi, login, refresh token, logout, dan OTP. |
| Users | `/api/users` | Profil pengguna, update profil, dan avatar. |
| Articles | `/api/articles` | Daftar artikel, kategori artikel, dan detail artikel. |
| Education | `/api/education` | Kategori edukasi dan detail konten edukasi. |
| Community Posts | `/api/posts` | Feed, postingan, like, komentar, dan hapus postingan. |
| Chatbot AI | `/api/chat` | Kirim pesan, riwayat chat, dan hapus riwayat. |
| Notifications | `/api/notifications` | Daftar notifikasi dan status baca. |

## Perintah Pengembangan

| Perintah | Fungsi |
|---|---|
| `flutter pub get` | Mengunduh dependensi proyek. |
| `flutter run` | Menjalankan aplikasi pada device aktif. |
| `flutter devices` | Menampilkan daftar device yang tersedia. |
| `flutter analyze` | Memeriksa kualitas kode dan potensi masalah statis. |
| `flutter test` | Menjalankan test pada folder `test/`. |
| `flutter clean` | Membersihkan file build sementara. |
| `flutter pub outdated` | Memeriksa dependensi yang memiliki versi lebih baru. |

## Catatan Pengembangan

- Pastikan backend berjalan sebelum menguji fitur yang membutuhkan API.
- Perbarui `API_URL` ketika URL backend atau tunnel berubah.
- Jangan menyimpan token, password, atau kredensial sensitif di repository.
- Jalankan `flutter analyze` dan `flutter test` setelah mengubah kode aplikasi.
