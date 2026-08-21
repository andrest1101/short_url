##  Features

- **🔗 Smart URL Shortening:** Generates reliable short links using the TinyURL API, with a local fallback mechanism to ensure offline robustness.
- **☁️ Cloud Persistence:** Automatically syncs and saves all generated URL history to **Firebase Firestore** in real-time.
- **📱 QR Code Integration:** Instantly generate and toggle a customized QR code for any shortened URL on demand.
- **🌐 Direct Browser Launch:** Seamlessly open shortened links directly in your default external browser using `url_launcher`.
- **📋 One-Tap Actions:** Quick clipboard copying for shortened links.
- **🧼 Clean Architecture:** Strictly decoupled into Domain, Data, and Presentation layers for maximum testability and scalability.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** Flutter / Dart
- **State Management:** Riverpod
- **Backend / Database:** Firebase Firestore (`cloud_firestore`, `firebase_core`)
- **API Integration:** TinyURL Public API (`http`)
- **Utilities:** 
  - `qr_flutter` (QR Code rendering)
  - `url_launcher` (External link handling)
  - `shared_preferences` (Local storage handling)

---

## 📂 Project Structure (Clean Architecture)

```text
lib/
│
├── data/
│   ├── datasources/   # Firebase Firestore & API data sources
│   ├── models/        # Data models & JSON serialization
│   └── repositories/  # Repository implementations
│
├── domain/
│   ├── entities/      # Core business objects
│   ├── repositories/  # Abstract repository interfaces
│   └── usecases/      # Business logic use cases
│
├── presentation/
│   ├── pages/         # UI Screens (UrlShortenerPage)
│   └── providers/     # Riverpod state notifiers & providers
│
└── main.html / main.dart # App entry point & Firebase initialization

```

---

## 📱 Screenshots & UI Preview

> Clean, minimal, and user-friendly interface designed with Flutter Material 3 guidelines.

---

## ⚙️ Getting Started & Installation

To run this project locally on your machine, follow these steps:

1. **Clone the repository:**

```bash
   git clone [https://github.com/andrest1101/short_url.git](https://github.com/andrest1101/short_url.git)
   cd short_url
   

```

2. **Install dependencies:**

```bash
   flutter pub get
   

```

3. **Configure Firebase:**
* Set up your Firebase project in the [Firebase Console](https://console.firebase.google.com/).
* Run `flutterfire configure` to generate your custom `firebase_options.dart`.


4. **Run the app:**

```bash
   flutter run
   

```

---

## 💡 Author

* **Andre Robert Silitonga**
* GitHub: [@andrest1101](https://www.google.com/search?q=https://github.com/andrest1101)

---

*If you find this project helpful or interesting, feel free to give it a ⭐️ star on GitHub!*

```

---

### Cara Memasukkannya ke GitHub Lu:
1. Buka folder *project* `short_url` lu di VS Code.
2. Buat file baru di dalam folder utama (sejajar dengan folder `lib` dan file `pubspec.yaml`), beri nama **`README.md`**.
3. *Paste* teks di atas ke dalam file tersebut, lalu *save*.
4. Commit dan Push ke GitHub lu pakai perintah terminal:
   
```bash
   git add README.md
   git commit -m "docs: add professional README.md"
   git push origin main
   
