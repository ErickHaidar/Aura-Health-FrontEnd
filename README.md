# Aura Health Frontend

Aura Health adalah aplikasi frontend berbasis Flutter untuk layanan edukasi dan pendampingan informasi TBC. Aplikasi ini menyediakan antarmuka untuk autentikasi pengguna, dashboard kesehatan, konten edukasi, alur deteksi, komunitas, chatbot AI, profil, dan pengaturan aplikasi.

Frontend ini terhubung dengan backend Aura Health melalui REST API dan Socket.IO. Konfigurasi alamat backend dibaca dari file `.env` menggunakan variabel `API_URL`.

## Ringkasan Proyek

| Item | Keterangan |
|---|---|
| Nama aplikasi | Aura Health |
| Package | `aurahealth` |
| Platform utama | Mobile dengan Flutter |
| Bahasa | Dart |
| Framework | Flutter |
| State management | `provider` |
| Konfigurasi environment | `flutter_dotenv` |
| Komunikasi API | `http` |
| Realtime | `socket_io_client` |
| Penyimpanan lokal | `shared_preferences` |
| Dokumentasi API | `API_DOCS.md` |

## Fitur Frontend

| Modul | Deskripsi | Layar Terkait |
|---|---|---|
| Splash Screen | Menampilkan halaman awal dan memeriksa status pengguna sebelum masuk ke aplikasi. | `lib/screens/auth/splash_screen.dart` |
| Autentikasi | Menyediakan login, registrasi, dan verifikasi OTP. | `lib/screens/auth/` |
| Dashboard | Menampilkan ringkasan layanan, sapaan pengguna, dan artikel terbaru. | `lib/screens/main/home_screen.dart` |
| Edukasi TBC | Menyediakan daftar edukasi, kategori edukasi, dan detail konten edukasi. | `lib/screens/education/` |
| Artikel | Menampilkan daftar artikel dan detail artikel kesehatan. | `lib/screens/article/` |
| Alur Deteksi | Menampilkan panduan alur deteksi TBC dan informasi pendukung. | `lib/screens/detection/detection_flow_screen.dart` |
| Komunitas | Menyediakan feed komunitas, detail postingan, komentar, like, dan pembuatan postingan. | `lib/screens/community/` |
| Chatbot AI | Menyediakan ruang percakapan dengan chatbot untuk topik TBC. | `lib/screens/assistant/chatbot_screen.dart` |
| Profil | Menampilkan profil pengguna dan pengubahan data profil. | `lib/screens/profile/` |
| Pengaturan | Menyediakan pengaturan aplikasi, termasuk mode tema. | `lib/screens/profile/settings_screen.dart` |

## Teknologi dan Dependensi

| Dependensi | Fungsi |
|---|---|
| `flutter` | Framework utama untuk membangun aplikasi multiplatform. |
| `cupertino_icons` | Ikon bergaya iOS untuk komponen tertentu. |
| `google_fonts` | Penggunaan font dari Google Fonts. |
| `font_awesome_flutter` | Ikon tambahan dari Font Awesome. |
| `http` | Komunikasi REST API dengan backend. |
| `shared_preferences` | Penyimpanan data sederhana secara lokal. |
| `flutter_dotenv` | Membaca konfigurasi dari file `.env`. |
| `provider` | Pengelolaan state aplikasi, termasuk tema. |
| `image_picker` | Pengambilan gambar dari perangkat. |
| `cached_network_image` | Menampilkan dan menyimpan cache gambar dari jaringan. |
| `url_launcher` | Membuka URL atau aplikasi eksternal dari Flutter. |
| `socket_io_client` | Komunikasi realtime berbasis Socket.IO. |
| `google_maps_flutter` | Integrasi peta Google Maps. |

## Kebutuhan Sistem

| Kebutuhan | Rekomendasi |
|---|---|
| Flutter SDK | Mengikuti versi yang mendukung Dart SDK `^3.11.0` |
| Dart SDK | `^3.11.0` sesuai `pubspec.yaml` |
| IDE | Visual Studio Code atau Android Studio |
| Android tooling | Android Studio, Android SDK, dan emulator atau perangkat fisik |
| iOS tooling | Xcode dan CocoaPods jika menjalankan target iOS |
| Backend | Backend Aura Health berjalan dan dapat diakses oleh aplikasi |
| Environment file | File `.env` tersedia di root folder frontend |

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
| `web/` | Konfigurasi dan aset untuk target web. |
| `android/`, `ios/`, `linux/`, `macos/`, `windows/` | Konfigurasi platform Flutter. |

## Konfigurasi Environment

Aplikasi membaca konfigurasi backend dari file `.env` di root folder frontend. File tersebut harus tersedia karena `lib/main.dart` memuat environment dengan `dotenv.load(fileName: ".env")`.

Contoh isi file `.env`:

```env
API_URL=http://localhost:3000
```

Untuk perangkat fisik atau emulator yang tidak dapat mengakses `localhost` komputer secara langsung, gunakan URL yang dapat dijangkau perangkat, misalnya alamat IP lokal komputer atau URL tunnel seperti Ngrok.

| Target | Contoh `API_URL` | Catatan |
|---|---|---|
| Flutter Web lokal | `http://localhost:3000` | Web dapat mengakses backend lokal melalui browser. |
| Android Emulator | `http://10.0.2.2:3000` | `10.0.2.2` mengarah ke host machine dari emulator Android. |
| Perangkat fisik | `http://192.168.1.10:3000` | Gunakan IP lokal komputer yang menjalankan backend. |
| Tunnel publik | `https://nama-tunnel.ngrok-free.app` | Digunakan jika perangkat membutuhkan akses melalui internet. |

## Instalasi dan Menjalankan Aplikasi

1. Masuk ke folder frontend.

```bash
cd frontend
```

2. Ambil seluruh dependensi Flutter.

```bash
flutter pub get
```

3. Pastikan file `.env` tersedia dan berisi `API_URL` yang benar.

```env
API_URL=http://localhost:3000
```

4. Jalankan backend Aura Health sesuai dokumentasi backend, lalu pastikan endpoint API dapat diakses.

5. Jalankan aplikasi Flutter.

```bash
flutter run
```

Jika terdapat beberapa device, pilih target dengan melihat daftar device terlebih dahulu.

```bash
flutter devices
flutter run -d <device-id>
```

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

Header request default mencakup `Content-Type`, `Accept`, dan `ngrok-skip-browser-warning`. Jika token tersedia, request juga menyertakan header `Authorization: Bearer <token>`.

## Routing Aplikasi

Route utama didefinisikan di `lib/main.dart` melalui `MaterialApp`.

| Route | Halaman |
|---|---|
| `/` | Splash Screen |
| `/login` | Login Screen |
| `/register` | Register Screen |
| `/otp` | OTP Screen |
| `/main` | Main Screen |

## Testing dan Validasi

Gunakan perintah berikut sebelum menyerahkan perubahan kode frontend.

```bash
flutter analyze
flutter test
```

Test yang tersedia saat ini berada di folder `test/`, termasuk pengujian untuk edit profil dan theme provider.

## Tim Pengembang

| Nama | Peran |
|---|---|
| Erick Haidar | Front-End Developer |
| Fajar | Backend Developer |
| Rizki | Backend Developer |

## Catatan Pengembangan

- Pastikan backend berjalan sebelum menguji fitur yang membutuhkan API.
- Perbarui `API_URL` ketika URL backend atau tunnel berubah.
- Jangan menyimpan token, password, atau kredensial sensitif di repository.
- Jalankan `flutter analyze` dan `flutter test` setelah mengubah kode aplikasi.
