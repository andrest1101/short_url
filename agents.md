# 🤖 AI Coding Agent Guidelines - Posture Guard Flutter Project

Dokumen ini berisi standar kerja & aturan wajib bagi AI Agent di repository Flutter project ini.

---

## 1. Project Context & Environment

- **Framework:** Flutter (Dart)
- **Target Platform:** Android Mobile Device
- **UI Architecture:** Feature-first approach, menggunakan widget modular (Stack, Positioned, CustomPaint).

## 2. Code Quality & Flutter Standards

- Tulis kode widget yang modular dan bersih. Pisahkan widget UI ke dalam komponen kecil jika sudah terlalu panjang.
- Patuhi aturan linting resmi Flutter (`analysis_options.yaml`).
- Gunakan ternary operator (`kondisi ? true : false`) dengan cermat untuk logika perubahan warna atau teks UI.
- Pastikan kode bebas dari error analisis dengan menjalankan: `flutter analyze`.

## 3. Git Workflow & Best Practices

1. **Granular Commit:** Lakukan `git commit` untuk setiap 1 tugas/fitur kecil yang selesai dikerjakan.
2. **Safe Push:** Lakukan `git push` hanya setelah memastikan aplikasi bisa di-_compile_ dan tidak ada error sintaks Dart.

## 4. Restrictions (Yang Dilarang)

- ❌ Dilarang melakukan _push_ atau _commit_ kodingan Flutter yang masih error.
- ❌ Dilarang mengubah struktur folder utama `lib/` tanpa instruksi spesifik.
- ❌ Dilarang menyertakan _credentials_ atau data sensitif langsung di dalam kode Dart.
