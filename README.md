<div align="center">

# 🔗 URL Shortener

**Aplikasi pemendek URL berbasis Flutter dengan Clean Architecture, state management Riverpod, persistensi cloud Firebase Firestore, dan QR Code interaktif.**

![Flutter](https://img.shields.io/badge/Flutter-3.8%2B-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8%2B-0175C2?logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-3.x-59C1F2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

</div>

---

## 📑 Daftar Isi

- [Tentang Project](#-tentang-project)
- [Fitur Utama](#-fitur-utama)
- [Tech Stack](#️-tech-stack)
- [Arsitektur](#️-arsitektur)
- [Struktur Project](#-struktur-project-clean-architecture)
- [Alur Data](#-alur-data)
- [Skema Database Firestore](#-skema-database-firestore)
- [Cara Menjalankan Project](#️-cara-menjalankan-project)
- [Screenshot](#-screenshot)
- [Roadmap](#-roadmap)
- [Author](#-author)
- [License](#-license)

---

## 📖 Tentang Project

**URL Shortener** adalah aplikasi mobile yang memungkinkan pengguna mengubah URL panjang menjadi link pendek dalam sekali ketuk. Setiap link yang berhasil dibuat akan otomatis tersimpan ke **Firebase Firestore**, sehingga riwayat tetap aman dan dapat diakses kembali kapan saja.

Project ini dibangun sebagai portofolio penerapan **Clean Architecture** di Flutter — pemisahan tanggung jawab yang tegas antara *Domain*, *Data*, dan *Presentation* layer — dikombinasikan dengan **Riverpod** untuk dependency injection dan state management yang reaktif serta mudah diuji.

---

## ✨ Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 🔗 **URL Shortening** | Memendekkan URL melalui **TinyURL Public API** dengan validasi respons dan timeout 15 detik untuk mencegah request menggantung. |
| ☁️ **Cloud Persistence** | Seluruh riwayat link otomatis tersinkronisasi ke **Firebase Firestore** (koleksi `short_urls`) dan dimuat ulang saat aplikasi dibuka. |
| ✅ **Validasi & Normalisasi URL** | Input seperti `www.contoh.com` otomatis dinormalisasi menjadi `https://www.contoh.com`; URL tidak valid ditolak sebelum menyentuh API. |
| 📱 **QR Code Interaktif** | Generate & tampilkan QR Code untuk setiap link pendek secara on-demand — cukup satu ketuk untuk menampilkan/menyembunyikan. |
| 🌐 **Buka di Browser** | Membuka link langsung di browser eksternal, dengan fallback otomatis ke *in-app browser view* apabila gagal. |
| 📋 **Salin ke Clipboard** | Salin link pendek ke clipboard dengan satu ketuk, lengkap dengan notifikasi konfirmasi. |
| 🗑️ **Swipe-to-Delete** | Hapus riwayat dengan gesture swipe menggunakan pola *optimistic update* — state langsung diperbarui dan di-*rollback* otomatis jika penghapusan di server gagal. |
| 🧭 **Penanganan Error yang Baik** | Loading indicator, error state dengan tombol *retry*, serta feedback `SnackBar` yang informatif untuk setiap aksi pengguna. |
| 🎨 **Material 3** | UI modern berbasis Material You dengan skema warna dinamis (`ColorScheme.fromSeed`). |

---

## 🛠️ Tech Stack

| Kategori | Teknologi | Package |
|----------|-----------|---------|
| **Framework** | Flutter (Dart SDK `^3.8.1`) | — |
| **State Management & DI** | Riverpod (`AsyncNotifier`, `Provider`) | `flutter_riverpod: ^3.3.2` |
| **Backend / Database** | Firebase Firestore | `firebase_core: ^4.13.0`, `cloud_firestore: ^6.8.0` |
| **API Integration** | TinyURL Public API (REST) | `http: ^1.6.0` |
| **QR Code** | Rendering QR Code native | `qr_flutter: ^4.1.0` |
| **External Link** | URL Launcher | `url_launcher: ^6.3.2` |

---

## 🏗️ Arsitektur

Project ini menerapkan **Clean Architecture** dengan tiga lapisan utama yang aturan dependensinya selalu mengarah ke dalam (*Domain*):

```text
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                    │
│   UI (UrlShortenerPage)  ←→  Riverpod Providers         │
│         (ConsumerStatefulWidget, AsyncNotifier)         │
└──────────────────────────┬──────────────────────────────┘
                           │ memanggil
┌──────────────────────────▼──────────────────────────────┐
│                      DOMAIN LAYER                       │
│   UseCases  ←→  Repository Interface (IUrlRepository)   │
│   Entities · Validator · Custom Exceptions              │
│        (Murni Dart — tanpa dependensi Flutter/Firebase) │
└──────────────────────────┬──────────────────────────────┘
                           │ diimplementasikan oleh
┌──────────────────────────▼──────────────────────────────┐
│                       DATA LAYER                        │
│              Repository Implementation                  │
│    ┌────────────────────┬───────────────────────────┐   │
│    │ TinyURL API        │ Firebase Firestore        │   │
│    │ Data Source        │ Data Source               │   │
│    └────────────────────┴───────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### Prinsip yang Diterapkan

- **Dependency Rule** — Presentation bergantung pada Domain, Data mengimplementasikan kontrak Domain. Tidak ada layer yang melompat (*skip*) atau terbalik.
- **Dependency Inversion** — `Domain` hanya mendefinisikan interface `IUrlRepository`; implementasinya (`UrlRepositoryImpl`) disuntikkan lewat Riverpod di `injection.dart`.
- **Single Responsibility** — Setiap UseCase memiliki satu tugas spesifik: `ShortenUrlUseCase`, `GetHistoryUseCase`, dan `DeleteHistoryUseCase`.
- **Framework Independence** — Layer Domain sepenuhnya murni Dart tanpa import Flutter/Firebase, sehingga mudah di-unit-test.

---

## 📂 Struktur Project (Clean Architecture)

```text
lib/
│
├── main.dart                          # Entry point & inisialisasi Firebase
├── injection.dart                     # Dependency injection via Riverpod Provider
├── firebase_options.dart              # Konfigurasi Firebase (generated by flutterfire)
│
├── domain/                            # 💼 CORE BUSINESS LOGIC (murni Dart)
│   ├── entities/
│   │   └── short_url_entity.dart      # Entitas utama: originalUrl, shortUrl, createdAt
│   ├── repositories/
│   │   └── url_repository.dart        # Abstract contract (IUrlRepository)
│   ├── usecases/
│   │   ├── shorten_url_usecase.dart   # Validasi input → normalisasi → shorten
│   │   ├── get_history_usecase.dart   # Mengambil riwayat dari repository
│   │   └── delete_history_usecase.dart# Menghapus item riwayat
│   ├── exceptions/
│   │   └── invalid_url_exception.dart # Exception kustom URL tidak valid
│   └── utils/
│       └── url_validator.dart         # Normalisasi & validasi format URL
│
├── data/                              # 🗄️ IMPLEMENTASI DATA
│   ├── models/
│   │   └── short_url_model.dart       # Model extends Entity + serialisasi JSON
│   ├── datasources/
│   │   ├── tiny_url_api_data_source.dart   # Integrasi REST TinyURL API
│   │   └── firebase_url_data_source.dart   # CRUD koleksi Firestore 'short_urls'
│   └── repositories/
│       └── url_repository_impl.dart   # Implementasi IUrlRepository
│
└── presentation/                      # 🖥️ UI & STATE MANAGEMENT
    ├── pages/
    │   └── url_shortener_page.dart    # Screen utama (form, riwayat, QR, dialog)
    └── providers/
        └── url_shortener_provider.dart# UrlHistoryNotifier (AsyncNotifier)
```

---

## 🔄 Alur Data

Contoh alur ketika pengguna menekan tombol **Shorten**:

```text
1. Pengguna input URL → tekan tombol Shorten
        │
2. UrlShortenerPage memanggil
   UrlHistoryNotifier.shorten(url)          [Presentation]
        │
3. ShortenUrlUseCase.call(url)
   ├─ UrlValidator.normalize(url)           [Domain]
   │   └─ Auto tambahkan https:// untuk input www.*
   │   └─ Tolak & lempar InvalidUrlException jika tidak valid
        │
4. UrlRepositoryImpl.shortenUrl()           [Data]
   ├─ TinyUrlApiDataSource.shorten()
   │   └─ GET https://tinyurl.com/api-create.php?url=...
   │   └─ Validasi respons + timeout 15 detik
   └─ FirebaseUrlDataSource.addUrl()
       └─ Simpan dokumen baru ke koleksi short_urls
        │
5. State AsyncNotifier diperbarui (AsyncData)
   → UI rebuild otomatis → link baru muncul di atas daftar riwayat
```

> **Catatan desain:** Penghapusan riwayat menggunakan pola *optimistic update* — item langsung hilang dari UI, namun state dikembalikan (*rollback*) secara otomatis apabila operasi hapus di Firestore gagal.

---

## 🗃️ Skema Database Firestore

**Koleksi:** `short_urls`

| Field | Tipe | Deskripsi |
|-------|------|-----------|
| `originalUrl` | `string` | URL panjang asli yang dimasukkan pengguna |
| `shortUrl` | `string` | Link pendek hasil dari TinyURL API |
| `createdAt` | `timestamp` | Waktu pembuatan link (diurutkan *descending* saat load) |

Contoh dokumen:

```json
{
  "originalUrl": "https://contoh.com/artikel/sangat/panjang",
  "shortUrl": "https://tinyurl.com/27u9xkmp",
  "createdAt": "August 21, 2026 at 10:30:00 AM UTC+7"
}
```

---

## ⚙️ Cara Menjalankan Project

### Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.8.1`
- Akun [Firebase](https://console.firebase.google.com/) (gratis)
- Perangkat Android / emulator, atau platform lain yang didukung

### Langkah Instalasi

1. **Clone repository**

   ```bash
   git clone https://github.com/andrest1101/short_url.git
   cd short_url
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Konfigurasi Firebase**

   - Buat project baru di [Firebase Console](https://console.firebase.google.com/).
   - Aktifkan **Cloud Firestore** (mode *production* atau *test*).
   - Jalankan perintah berikut lalu ikuti instruksinya untuk meng-generate `lib/firebase_options.dart`:

     ```bash
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```

4. **Jalankan aplikasi**

   ```bash
   flutter run
   ```

---

## 📸 Screenshot

> Antarmuka bersih dan minimalis dengan panduan desain Material 3.

*(Screenshot akan segera ditambahkan)*

---

## 🗺️ Roadmap

- [ ] Local caching / offline fallback untuk riwayat link
- [ ] Unit test & widget test untuk UseCase dan Notifier
- [ ] Dukungan multi-bahasa (i18n)
- [ ] Custom alias pada link pendek
- [ ] Statistik jumlah klik per link

---

## 👤 Author

**Andre Robert Silitonga**

- GitHub: [@andrest1101](https://github.com/andrest1101)

---

## 📄 License

Project ini dilisensikan di bawah [MIT License](LICENSE).

---

<div align="center">

⭐️ Jika project ini bermanfaat atau menarik, jangan ragu untuk memberikan **star** di GitHub!

</div>
