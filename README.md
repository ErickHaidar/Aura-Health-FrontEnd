# 🩺 Aura Health: Platform Digital Edukasi dan Komunitas TBC

## Pendahuluan

Aura Health adalah aplikasi mobile berbasis Flutter yang dirancang untuk mendukung upaya edukasi dan penanggulangan penyakit Tuberkulosis (TBC). Platform ini menyediakan akses cepat terhadap informasi medis, panduan deteksi mandiri, serta ruang komunitas bagi pengguna untuk saling berbagi pengalaman.

Proyek ini dikembangkan untuk memenuhi tugas mata kuliah **Workshop Pemrograman Perangkat Bergerak**.

## Tim Pengembang

| Nama                   | Peran               |
| :--------------------- | :------------------ |
| **Erick Haidar** | Front-End Developer |
| **Fajar**        | Backend Developer   |
| **Rizqi**        | Backend Developer   |

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

| Komponen                     | Spesifikasi                   |
| :--------------------------- | :---------------------------- |
| **Framework**          | [Flutter](https://flutter.dev/)  |
| **Bahasa Pemrograman** | Dart                          |
| **State Management**   | Provider                      |
| **Komunikasi API**     | Http Client                   |
| **Penyimpanan Lokal**  | Shared Preferences            |
| **Tipografi**          | Inter (via Google Fonts)      |
| **Ikonografi**         | Font Awesome & Material Icons |

## Panduan Instalasi

Pastikan perangkat Anda telah memenuhi spesifikasi minimum sebelum memulai proses instalasi.

### Prasyarat

- **Flutter SDK**: Versi terbaru pada channel stable.
- **IDE**: Visual Studio Code atau Android Studio dengan ekstensi Flutter terpasang.
- **Emulator/Perangkat**: Android atau iOS dengan fitur USB Debugging aktif.

### Langkah-langkah

1. Masuk ke direktori proyek:
   ```bash
   cd Aura-Health-FrontEnd
   ```
2. Instal semua dependensi yang diperlukan:
   ```bash
   flutter pub get
   ```

## Konfigurasi Backend dan Koneksi

Aplikasi menggunakan tunnel Ngrok untuk menghubungkan aplikasi mobile dengan server lokal.

1. Jalankan layanan backend pada port `3000`.
2. Aktifkan Ngrok melalui VS Code Task:
   - Tekan `Ctrl + Shift + P`.
   - Pilih **Tasks: Run Task**.
   - Pilih **Run Ngrok (Port 3000)**.
3. Sinkronisasi API URL:
   - Salin alamat Forwarding dari terminal Ngrok (contoh: `https://abcd-123.ngrok-free.dev`).
   - Buka file `.env` di direktori utama.
   - Perbarui nilai `API_URL` dengan alamat tersebut.

   ```env
   API_URL=https://alamat-ngrok-anda.ngrok-free.dev
   ```

## Menjalankan Aplikasi

Setelah konfigurasi selesai, jalankan perintah berikut untuk meluncurkan aplikasi:

```bash
flutter run
```

## Struktur Proyek

Berikut adalah struktur folder utama yang perlu diperhatikan dalam pengembangan:

- `lib/main.dart`: Titik masuk utama aplikasi dan konfigurasi routing.
- `lib/theme.dart`: Definisi skema warna (Teal), tipografi, dan tema global widget.
- `lib/screens/`: Berisi seluruh implementasi layar antarmuka pengguna.
- `lib/services/`: Logika komunikasi API dan layanan eksternal lainnya.
- `.env`: Berkas konfigurasi variabel lingkungan untuk API.

---

*Dokumentasi ini disusun untuk tujuan teknis dan akademis.*

## Pendahuluan

Aura Health adalah aplikasi mobile berbasis Flutter yang dirancang untuk mendukung upaya edukasi dan penanggulangan penyakit Tuberkulosis (TBC). Platform ini menyediakan akses cepat terhadap informasi medis, panduan deteksi mandiri, serta ruang komunitas bagi pengguna untuk saling berbagi pengalaman.

Proyek ini dikembangkan untuk memenuhi tugas mata kuliah **Workshop Pemrograman Perangkat Bergerak**.

## Tim Pengembang

| Nama                   | Peran               |
| :--------------------- | :------------------ |
| **Erick Haidar** | Front-End Developer |
| **Fajar**        | Backend Developer   |
| **Rizki**        | Backend Developer   |

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

| Komponen                     | Spesifikasi                   |
| :--------------------------- | :---------------------------- |
| **Framework**          | [Flutter](https://flutter.dev/)  |
| **Bahasa Pemrograman** | Dart                          |
| **State Management**   | Provider                      |
| **Komunikasi API**     | Http Client                   |
| **Penyimpanan Lokal**  | Shared Preferences            |
| **Tipografi**          | Inter (via Google Fonts)      |
| **Ikonografi**         | Font Awesome & Material Icons |

## Panduan Instalasi

Pastikan perangkat Anda telah memenuhi spesifikasi minimum sebelum memulai proses instalasi.

### Prasyarat

- **Flutter SDK**: Versi terbaru pada channel stable.
- **IDE**: Visual Studio Code atau Android Studio dengan ekstensi Flutter terpasang.
- **Emulator/Perangkat**: Android atau iOS dengan fitur USB Debugging aktif.

### Langkah-langkah

1. Masuk ke direktori proyek:
   ```bash
   cd Aura-Health-FrontEnd
   ```
2. Instal semua dependensi yang diperlukan:
   ```bash
   flutter pub get
   ```

## Konfigurasi Backend dan Koneksi

Aplikasi menggunakan tunnel Ngrok untuk menghubungkan aplikasi mobile dengan server lokal.

1. Jalankan layanan backend pada port `3000`.
2. Aktifkan Ngrok melalui VS Code Task:
   - Tekan `Ctrl + Shift + P`.
   - Pilih **Tasks: Run Task**.
   - Pilih **Run Ngrok (Port 3000)**.
3. Sinkronisasi API URL:
   - Salin alamat Forwarding dari terminal Ngrok (contoh: `https://abcd-123.ngrok-free.dev`).
   - Buka file `.env` di direktori utama.
   - Perbarui nilai `API_URL` dengan alamat tersebut.

   ```env
   API_URL=https://alamat-ngrok-anda.ngrok-free.dev
   ```

## Menjalankan Aplikasi

Setelah konfigurasi selesai, jalankan perintah berikut untuk meluncurkan aplikasi:

```bash
flutter run
```

## Struktur Proyek

Berikut adalah struktur folder utama yang perlu diperhatikan dalam pengembangan:

- `lib/main.dart`: Titik masuk utama aplikasi dan konfigurasi routing.
- `lib/theme.dart`: Definisi skema warna (Teal), tipografi, dan tema global widget.
- `lib/screens/`: Berisi seluruh implementasi layar antarmuka pengguna.
- `lib/services/`: Logika komunikasi API dan layanan eksternal lainnya.
- `.env`: Berkas konfigurasi variabel lingkungan untuk API.

---

*Dokumentasi ini disusun untuk tujuan teknis dan akademis.*
