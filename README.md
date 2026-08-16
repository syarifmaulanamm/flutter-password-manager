# 🛡️ My Password Manager

Aplikasi pengelola kata sandi (Password Manager) yang aman, dibangun menggunakan **Flutter**. Aplikasi ini dirancang untuk menyimpan kredensial Anda secara lokal dengan enkripsi tingkat tinggi, memastikan data sensitif Anda tetap privat dan terlindungi.

---

## ✨ Fitur Utama

- **🔐 Vault Terenkripsi**: Semua data kata sandi disimpan menggunakan enkripsi AES-256.
- **🏠 Manajemen Password**: Tambah, edit, dan hapus kredensial akun Anda dengan mudah.
- **🔑 Master Password**: Akses ke seluruh database dilindungi oleh satu kata sandi utama yang kuat.
- **📱 Antarmuka Modern**: UI yang bersih dan responsif menggunakan Material Design 3.
- **📴 Offline First**: Data disimpan sepenuhnya di perangkat Anda menggunakan SQLite, tanpa ketergantungan pada cloud.
- **💾 Penyimpanan Aman**: Kunci enkripsi disimpan dengan aman menggunakan `flutter_secure_storage` (Keychain/Keystore).

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Bahasa**: Kotlin (Android) & Dart
- **Database**: [sqflite](https://pub.dev/packages/sqflite) (SQLite)
- **Keamanan**:
  - [encrypt](https://pub.dev/packages/encrypt) (AES Encryption)
  - [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
  - [crypto](https://pub.dev/packages/crypto) (Hashing)
- **State Management**: [Provider](https://pub.dev/packages/provider)

---

## 🏗️ Arsitektur Proyek

Proyek ini mengikuti pola arsitektur berlapis untuk memudahkan pemeliharaan:

- `lib/core/`: Utilitas umum dan logika keamanan inti.
- `lib/data/`: Implementasi database dan repository.
- `lib/domain/`: Model data dan logika bisnis.
- `lib/ui/`: Layar (screens), widget, dan viewmodel.

---

## 🚀 Memulai (Getting Started)

### Prasyarat
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi terbaru di channel stable)
- Android Studio / VS Code
- Android SDK (dengan Command-line Tools terinstal)

### Instalasi

1. **Clone repositori**:
   ```bash
   git clone https://github.com/username/my_password_manager.git
   cd my_password_manager
   ```

2. **Instal dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

---

## 🔒 Catatan Keamanan

Aplikasi ini menggunakan pendekatan **Zero-Knowledge Architecture**. Pengembang tidak memiliki akses ke data Anda. Pastikan Anda tidak melupakan Master Password Anda, karena tidak ada fitur "Lupa Kata Sandi" demi menjaga integritas keamanan (data tidak dapat didekripsi tanpa kunci yang benar).

---

## 📝 Lisensi

Distribusi di bawah lisensi MIT. Lihat `LICENSE` untuk informasi lebih lanjut.
