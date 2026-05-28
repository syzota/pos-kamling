<div align="center">

<img width="1919" height="1010" alt="Screenshot 2026-05-28 132033" src="https://github.com/user-attachments/assets/1a4df981-cd72-42dd-950b-30c59b2bb2c5" />

# ✦ Pos Kamling
### *Administrasi RT dalam Satu Aplikasi*

<p>
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-Messaging-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/GetX-State_Management-8A2BE2?style=for-the-badge"/>
</p>

<p>
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=flat-square&logo=android&logoColor=white"/>
  <img src="https://img.shields.io/badge/Version-1.3.0-blue?style=flat-square"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square"/>
</p>

> *Platform digital untuk mempermudah komunikasi, pelayanan surat-menyurat, dan pengelolaan administrasi di lingkungan RT — modern, transparan, dan mudah diakses.*

</div>

---

## **Deskripsi Aplikasi** ★

Aplikasi **Pos Kamling** adalah platform manajemen RT digital berbasis Flutter yang dirancang untuk mendigitalisasi administrasi dan komunikasi warga di lingkungan Rukun Tetangga. Hadir sebagai solusi atas permasalahan pengelolaan RT yang masih manual — mulai dari pengarsipan surat, penyebaran pengumuman, hingga transparansi keuangan kas RT.

Sistem memiliki dua jenis pengguna: **Admin** yang mengelola seluruh data RT secara terpusat, dan **Warga** yang dapat mengakses informasi, mengajukan surat, serta memantau kegiatan dan keuangan RT secara real-time.

> Versi **1.3.0** · Android  
> Copyright © 2026 Tim Pos Kamling · IG [@vedaraki](https://instagram.com/vedaraki)

---

## **Fitur Aplikasi** ⸝⸝.ᐟ⋆.ᐟ

### Features Checklist ᯓ★

**Fitur Wajib:**
- [x] Login dengan NIK + Password + Tanggal Lahir
- [x] CRUD Data Warga — tambah, tampil, edit, hapus data penduduk
- [x] CRUD Pengumuman — kelola & distribusi pengumuman RT
- [x] CRUD Kegiatan — jadwal & manajemen kegiatan RT
- [x] CRUD Keuangan — catat pemasukan & pengeluaran kas RT
- [x] CRUD Surat — pengajuan, persetujuan, dan download surat

**Fitur Tambahan:**
- [x] Login biometrik (sidik jari / Face ID) via `local_auth`
- [x] Push notification real-time via Firebase Cloud Messaging
- [x] Kalender kegiatan interaktif dengan `table_calendar`
- [x] Chart visualisasi keuangan dengan `fl_chart`
- [x] QR Code identitas warga via `qr_flutter`
- [x] Export & preview laporan PDF via `flutter_pdfview`
- [x] Integrasi Google Maps + GPS lokasi warga
- [x] Session aman dengan `flutter_secure_storage`

---

## **Materi yang Diimplementasikan** ᯓ★

### Checklist Materi ⍟

- [x] **Widget** — Custom widget reusable: `GradientButton`, `QuickActionCard`, `AppShimmerImage`, `InfoTile`, `GlassContainer`, dll.
- [x] **State Management** — GetX (`GetxController`, `Obx`, `.obs`, `RxList`, `RxBool`) di seluruh modul
- [x] **Navigation** — Named routes terpusat via `AppPages` + `AppRoutes` + `GetX`
- [x] **Supabase** — CRUD semua tabel via `SupabaseProvider`, konfigurasi via `.env`
- [x] **Deployment** — Build APK Android, konfigurasi `.env` dengan `flutter_dotenv`

---

## **Widget yang Digunakan** ⸝⸝.ᐟ⋆.ᐟ

### Widget Bawaan Flutter ᯓ★

| Widget | Digunakan Pada |
|--------|---------------|
| `Scaffold` | Semua halaman utama |
| `AppBar` | Navigasi halaman detail |
| `BottomNavigationBar` | Navigasi utama Admin & Warga |
| `ListView` / `ListView.builder` | Daftar pengumuman, warga, surat, transaksi |
| `GridView` | Quick action cards di dashboard |
| `Column` / `Row` / `Stack` | Layout di seluruh halaman |
| `Container` / `Card` | Card komponen UI |
| `TextField` / `TextFormField` | Form input login, surat, data warga |
| `AlertDialog` | Konfirmasi aksi (logout, hapus, dll.) |
| `BottomSheet` | Form tambah/edit data |
| `TabBar` / `TabBarView` | Filter status pada surat & keuangan |
| `PageView` | Welcome / onboarding screen |
| `AnimatedBuilder` | Animasi splash screen |
| `ClipPath` / `CustomClipper` | Wave shape di welcome screen |
| `CustomPaint` | Pattern background dekoratif |
| `FutureBuilder` / `StreamBuilder` | Data async dari Supabase |
| `SliverAppBar` / `CustomScrollView` | Collapsible header di dashboard |
| `RefreshIndicator` | Pull-to-refresh data |
| `GestureDetector` / `InkWell` | Tap handler komponen interaktif |

### Custom Widget (Reusable) ᯓ★

| Widget | Deskripsi |
|--------|-----------|
| `GradientButton` | Tombol dengan gradient warna primer |
| `QuickActionCard` | Kartu menu aksi cepat dengan icon + label |
| `AppShimmerImage` | Image dengan efek shimmer loading |
| `InfoTile` | Baris info label–value dengan icon |
| `SettingsTile` | Item menu pengaturan dengan chevron |
| `ProfileHeader` | Header profil dengan foto, nama, role badge |
| `ProfileAvatarButton` | Tombol avatar profil di AppBar |
| `AppBottomNav` | Bottom navigation bar kustom |
| `AppSnackbar` | Snackbar sukses/error yang konsisten |
| `GlassContainer` | Container dengan efek glassmorphism |
| `AppBackground` | Background gradient aplikasi |
| `PdfViewerScreen` | Halaman fullscreen viewer PDF |

---

## **State Management** ⊹ ࣪ ˖ ✔

Aplikasi menggunakan **GetX** dengan pola **MVC + Binding**:

```dart
// Controller — state reaktif
class AdminDashboardController extends GetxController {
  final totalWarga    = 0.obs;
  final isLoading     = false.obs;
  final recentKegiatan = <KegiatanModel>[].obs;
}

// View — reaktif dengan Obx
Obx(() => Text('Total Warga: ${controller.totalWarga.value}'))

// Binding — dependency injection
class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminDashboardController(
      pendudukRepo: PendudukRepository(),
    ));
  }
}
```

---

## **Navigasi** ⊹ ࣪ ˖ ✔

Navigasi menggunakan **Named Routes** GetX yang didefinisikan terpusat:

```
lib/app/routes/
├── app_routes.dart   ← Konstanta nama route
└── app_pages.dart    ← Mapping route → View + Binding
```

```dart
// Navigasi antar halaman
Get.toNamed(AppRoutes.adminResidents);        // Push
Get.offAllNamed(AppRoutes.wargaDashboard);    // Replace semua
Get.back();                                   // Pop
```

**Alur navigasi berdasarkan role:**

```
Splash → [cek token + role]
              ├── admin   → AdminDashboard
              ├── warga   → WargaDashboard
              └── kosong  → WelcomeScreen → Login
```

---

## **Supabase** ⊹ ࣪ ˖ ✔

Seluruh operasi data menggunakan **Supabase** via `SupabaseProvider`, dikonfigurasi dengan `flutter_dotenv`:

```dart
// main.dart — inisialisasi via .env
await dotenv.load(fileName: '.env');
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
);
```

**Tabel Supabase:** ᯓ★

| Tabel | Keterangan |
|-------|-----------|
| `penduduk` | Data warga + kredensial + FCM token |
| `pengumuman` | Pengumuman dari admin |
| `kegiatan` | Jadwal kegiatan RT |
| `keuangan` | Pemasukan & pengeluaran kas |
| `surat` | Pengajuan dan status surat warga |
| `notifikasi` | Riwayat notifikasi per warga |

```dart
// Contoh CRUD
await SupabaseProvider.kegiatanTable.insert(kegiatan.toJson());

await SupabaseProvider.pendudukTable
    .update(data).eq('id_penduduk', id);

await SupabaseProvider.keuanganTable
    .delete().eq('id_keuangan', id);
```

> ◆ File `.env` **wajib** di-ignore dari Git  
> ◆ API Key **tidak boleh** ditulis langsung di kode

---

## **Package Nilai Tambah** ᯓ★

Package berikut digunakan sebagai nilai tambah di luar yang diajarkan di praktikum:

| Package | Versi | Kegunaan |
|---------|:-----:|---------|
| `fl_chart` | ^0.67.0 | Chart visualisasi keuangan RT |
| `table_calendar` | ^3.1.0 | Kalender interaktif jadwal kegiatan |
| `local_auth` | ^2.2.0 | Login biometrik (sidik jari / Face ID) |
| `qr_flutter` | ^4.1.0 | Generate QR code identitas warga |
| `flutter_animate` | ^4.5.0 | Animasi UI halus (fade, slide, scale) |
| `google_maps_flutter` | ^2.6.0 | Tampilan peta lokasi warga |
| `geolocator` | ^10.1.0 | Deteksi GPS lokasi warga |
| `geocoding` | ^2.1.1 | Konversi koordinat ke alamat teks |
| `flutter_pdfview` | ^1.3.2 | Preview dokumen PDF surat |
| `firebase_messaging` | ^16.2.1 | Push notification via FCM |
| `flutter_local_notifications` | ^17.0.0 | Notifikasi lokal + deep link |
| `fancy_shimmer_image` | ^2.0.3 | Image loading dengan shimmer elegan |
| `flutter_svg` | ^2.0.10 | Render aset SVG (logo, ilustrasi) |
| `share_plus` | ^10.0.0 | Share dokumen ke aplikasi lain |
| `file_picker` | ^8.0.0 | Pilih file dari perangkat |
| `image_picker` | ^1.0.7 | Ambil foto kamera/galeri untuk profil |
| `flutter_secure_storage` | ^9.2.2 | Simpan session token secara aman |
| `equatable` | ^2.0.5 | Perbandingan objek model efisien |

---

## **Library Structure** ⊹ ࣪ ˖ ✔

```
pos_kamling/
│
├── 📂 lib/
│   ├── main.dart                    → Entry point aplikasi
│   │
│   ├── 📂 app/routes/
│   │   ├── app_pages.dart           → Definisi route + binding
│   │   └── app_routes.dart          → Konstanta nama route
│   │
│   ├── 📂 core/
│   │   ├── 📂 constants/            → Warna, dimensi, konstanta
│   │   ├── 📂 services/             → Biometric, Location, Notification, Session
│   │   ├── 📂 theme/                → AppTheme (light theme)
│   │   └── 📂 widgets/              → Custom widget reusable
│   │
│   ├── 📂 data/
│   │   ├── 📂 models/               → Model data (Penduduk, Surat, dll.)
│   │   ├── 📂 providers/            → Supabase & Storage provider
│   │   └── 📂 repositories/         → Repository per entitas
│   │
│   ├── 📂 modules/
│   │   ├── 📂 auth/                 → Login, Welcome screen
│   │   ├── 📂 splash/               → Splash screen
│   │   ├── 📂 profile/              → Profil, Edit Profil, Keamanan
│   │   │
│   │   ├── 📂 admin/
│   │   │   ├── dashboard/           → Dashboard admin + statistik
│   │   │   ├── residents/           → Kelola data warga (CRUD)
│   │   │   ├── announcement/        → Kelola pengumuman (CRUD)
│   │   │   ├── activities/          → Kelola kegiatan (CRUD)
│   │   │   ├── finance/             → Kelola keuangan (CRUD)
│   │   │   ├── letters/             → Kelola surat (CRUD + approve)
│   │   │   ├── notification/        → Kirim notifikasi ke warga
│   │   │   └── laporan/             → Laporan & export PDF
│   │   │
│   │   └── 📂 warga/
│   │       ├── dashboard/           → Dashboard warga
│   │       ├── announcement/        → Lihat pengumuman
│   │       ├── calendar/            → Kalender kegiatan interaktif
│   │       ├── finance/             → Pantau keuangan RT
│   │       ├── letter/              → Ajukan & pantau surat
│   │       ├── notification/        → Riwayat notifikasi
│   │       └── fasilitas/           → Lapor fasilitas (coming soon)
│   │
│   └── 📂 widgets/                  → Widget global (AppBackground, GlassContainer)
│
├── 📂 assets/images/                → Logo SVG, ilustrasi
├── .env                             → Konfigurasi sensitif (tidak di-commit!)
└── pubspec.yaml
```

---

## **Program Flows** ⭑ & Graphical User Interface (GUI) —͟͟͞͞★

### Alur Autentikasi ⍟
> 📌 *Login dengan NIK + Password + Tanggal Lahir, atau sidik jari*

---

### Dashboard Admin ⍟
> 📌 *Ringkasan total warga, surat pending, transaksi terbaru, dan quick action menu*

---

### Dashboard Warga ⍟
> 📌 *Pengumuman terbaru, kegiatan mendatang, shortcut fitur utama*

---

### CRUD Data Warga ⍟
> 📌 *Tambah, tampil, edit, hapus data penduduk dengan pencarian NIK/nama*

---

### Pengajuan Surat ⍟
> 📌 *Form pengajuan → tracking status → download PDF surat*

---

### Keuangan RT ⍟
> 📌 *Catat pemasukan & pengeluaran, chart visualisasi, laporan PDF*

---

### Kalender Kegiatan ⍟
> 📌 *Kalender interaktif, highlight tanggal kegiatan, detail per hari*

---

### Notifikasi ⍟
> 📌 *Push notification real-time, deep link ke halaman terkait*

---

## **Cara Menjalankan** ᯓ★

### Setup ⍟

**1. Clone repositori**
```bash
git clone https://github.com/[username]/pos-kamling.git
cd pos-kamling
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Buat file `.env`** di root proyek
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

**4. Jalankan aplikasi**
```bash
flutter run
```

**5. Build APK**
```bash
flutter build apk --release
```
---

## **Mata Kuliah** ★

> **Pemrograman Aplikasi Bergerak**  
> Program Studi Sistem Informasi — Fakultas Teknik  
> **Universitas Mulawarman** · 2025/2026

---

<div align="center">

*© 2026 Pos Kamling — Sistem Informasi, Universitas Mulawarman*

</div>
