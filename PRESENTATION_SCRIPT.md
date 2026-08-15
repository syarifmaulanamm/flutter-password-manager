# 🎤 NASKAH PRESENTASI UAS
## Mata Kuliah: Pemrograman Berbasis Perangkat Bergerak
**Prodi S1 Sistem Informasi — Universitas Siber Asia (UNSIA)**
**Nama Proyek**: Secure Password Manager Mobile Application

---

## ⏱️ Alokasi Waktu Total: ~7 - 10 Menit

---

### 🎙️ SLIDE 1: Pembukaan & Perkenalan (1 Menit)

**Tampilan Slide**: Judul Proyek, Nama Mahasiswa, NIM, Logo UNSIA.

**Naskah Bicara**:
> *"Selamat pagi/siang Bapak/Ibu Dosen Pengampu serta rekan-rekan sekalian.*
> 
> *Perkenalkan, saya Syarif Maulana dari Program Studi S1 Sistem Informasi Universitas Siber Asia. Hari ini saya akan mempresentasikan hasil proyek Ujian Akhir Semester (UAS) mata kuliah Pemrograman Berbasis Perangkat Bergerak, yaitu aplikasi **Secure Password Manager berbasis Flutter & Dart**.*
> 
> *Di era digital saat ini, setiap orang memiliki puluhan akun online. Kebiasaan menggunakan password yang sama di banyak tempat atau mencatatnya secara asal sangat rentan terhadap kebocoran data. Oleh karena itu, saya merancang aplikasi ini untuk memberikan solusi penyimpanan password lokal yang aman, cepat, dan mudah digunakan."*

---

### 🎙️ SLIDE 2: Latar Belakang & Pendekatan Keamanan (1.5 Menit)

**Tampilan Slide**: Poin *Zero-Cloud Trust Architecture* & Diagram Keamanan Enkripsi.

**Naskah Bicara**:
> *"Aplikasi ini mengadopsi prinsip **Zero-Cloud Trust Architecture**. Artinya, aplikasi tidak menyimpan data apa pun di server cloud pihak ketiga. Semua data tersimpan 100% secara lokal di perangkat pengguna.*
> 
> *Untuk menjamin keamanan tingkat tinggi, aplikasi ini menggunakan 5 lapis proteksi utama:*
> 1. **Enkripsi AES-256 Bit dengan Mode CBC**: Setiap password dienkripsi dengan Initialization Vector (IV 128-bit) acak sebelum disimpan ke database SQLite.
> 2. **Hardware-Backed Keystore**: Kunci enkripsi AES disimpang secara aman di Android Keystore melalui `flutter_secure_storage`.
> 3. **Otentikasi Master PIN dengan Hashing SHA-256 + Salt**: Master PIN pengguna di-hash menggunakan algoritma SHA-256 dan Salt berbasis waktu.
> 4. **Anti-Screenshot & Recording (`FLAG_SECURE`)**: Memblokir aksi screenshot dan perekaman layar oleh aplikasi berbahaya.
> 5. **Auto-Clear Clipboard (30 Detik)**: Menghapus teks password yang disalin ke clipboard secara otomatis setelah 30 detik."*

---

### 🎙️ SLIDE 3: Arsitektur Software — MVVM Pattern (1.5 Menit)

**Tampilan Slide**: Bagan Arsitektur MVVM (Model, View, ViewModel, Repository, Data Source).

**Naskah Bicara**:
> *"Dari sisi arsitektur kode, aplikasi ini menerapkan **Pola MVVM (Model-View-ViewModel)** yang dipadukan dengan **Repository Pattern**.*
> 
> *Pemisahan layer ini dibuat sangat rapi:*
> - **Domain Layer**: Berisi entity `PasswordEntry`.
> - **Data Layer**: Terdiri dari `DatabaseHelper` untuk operasi SQLite, `AuthRepository` untuk PIN security, dan `PasswordRepository` yang menjembatani enkripsi dengan database.
> - **UI Layer**: Menggunakan `AuthViewModel` dan `PasswordViewModel` sebagai *state management* (berbasis Provider) yang menggerakkan tampilan UI seperti `PinScreen`, `HomeScreen`, dan dialog-dialog modal.
> 
> *Arsitektur ini membuat kode sangat mudah diuji (*testable*), rapi (*clean code*), dan mudah dikembangkan di masa mendatang."*

---

### 🎙️ SLIDE 4: Demonstrasi Aplikasi / Demo Live (3 Menit)

**Tampilan Slide**: Screen Recording / Demo Live Emulator Android.

**Naskah Bicara**:
> *"Sekarang mari kita lihat demonstrasi langsung dari aplikasi ini.*
> 
> 1. **Pertama (Setup PIN)**: Saat aplikasi dibuka pertama kali, pengguna diminta membuat Master PIN 6 digit. PIN ini diset dan di-hash secara aman.
> 2. **Kedua (Tambah Password & Generator)**: Ketika kita menekan tombol **+ Tambah Entri**, kita bisa mengisi nama layanan seperti 'Google' dan username. Di sini ada fitur **Password Generator** (ikon 🪄). Pengguna bisa menentukan panjang karakter dan kombinasi simbol untuk membuat password yang kuat dalam satu klik.
> 3. **Ketiga (Show/Hide & Copy)**: Data yang tersimpan akan tertutup karakter titik-titik `••••••••`. Jika tombol mata ditekan, password akan didekripsi dan ditampilkan. Tombol copy akan menyalin password dan mengaktifkan timer hapus otomatis 30 detik.
> 4. **Keempat (Fitur Auto-Lock)**: Jika pengguna tidak menyentuh aplikasi selama 3 menit atau mengembalikan aplikasi ke background, aplikasi secara otomatis terkunci kembali demi keamanan."*

---

### 🎙️ SLIDE 5: Kesimpulan & Penutup (1 Menit)

**Tampilan Slide**: Ringkasan Poin Keunggulan & Ucapan Terima Kasih.

**Naskah Bicara**:
> *"Sebagai kesimpulan, aplikasi Password Manager ini berhasil mengintegrasikan teknologi **Flutter**, database **SQLite**, serta keamanan **AES-256** dan **MVVM Architecture** sesuai spesifikasi tugas UAS Pemrograman Berbasis Perangkat Bergerak.*
> 
> *Aplikasi ini siap digunakan sebagai brankas password pribadi yang aman, responsif, dan terproteksi.*
> 
> *Demikian presentasi dari saya. Terima kasih atas perhatian Bapak/Ibu Dosen dan rekan-rekan sekalian. Saya menyambut baik jika ada pertanyaan atau masukan. Terima kasih!"*

---
