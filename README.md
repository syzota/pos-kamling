# Proyek Akhir Pemrograman Aplikasi Bergerak 2026

Repositori ini dibuat sebagai bagian dari pengembangan Sistem Informasi RT Digital oleh:

**1. HENDRI ZAIDAN SAFITRA (2409116013)**

**2. PUTRI SYAFANA AFRILLIA (2409116015)**

**3. INDAH PUTRI LESTARI (2409116004)**

**4. NARENDRA AUGUSTA SRIANANDHA (2409116010)**

Proyek ini dikembangkan untuk memenuhi tugas mata kuliah sekaligus sebagai solusi dalam membantu pengelolaan administrasi di lingkungan Rukun Tetangga (RT) agar lebih terintegrasi dan efisien.

# Deskripsi Aplikasi

Aplikasi yang dikembangkan merupakan Sistem Informasi RT Digital berbasis aplikasi mobile yang dirancang untuk membantu pengelolaan administrasi dan pelayanan di lingkungan Rukun Tetangga (RT).

Latar belakang pembuatan aplikasi ini adalah masih digunakannya metode manual dalam proses administrasi, seperti permintaan surat pengantar yang dilakukan secara langsung serta penyimpanan data penduduk menggunakan file Excel. Hal tersebut menyebabkan kesulitan dalam pencarian data, monitoring status penduduk, serta kurangnya efisiensi dalam pelayanan kepada warga.

Oleh karena itu, aplikasi ini dikembangkan sebagai solusi digital yang terintegrasi dan dapat diakses melalui perangkat mobile oleh Ketua RT sebagai administrator dan warga sebagai pengguna. Sistem ini memungkinkan seluruh data dan layanan administrasi dikelola dalam satu platform yang terpusat, sehingga lebih mudah diakses, diperbarui, dan dipantau secara real-time.

Melalui aplikasi ini, proses pengajuan surat menjadi lebih praktis, data penduduk dapat dikelola dengan lebih terstruktur, serta informasi kegiatan dan keuangan RT dapat disampaikan secara transparan kepada seluruh warga.

# Dokumentasi Proyek

## Struktur Library

## Fitur Ketua RT (Admin)

### 1. Kelola Data Penduduk

Ketua RT dapat mengelola seluruh data warga secara terpusat, mulai dari menambahkan, mengubah, hingga memperbarui informasi penduduk. Dengan fitur ini, data warga menjadi lebih terstruktur, mudah diakses, dan selalu terjaga keakuratannya.

### 2. Kelola Surat Pengantar

Fitur ini memungkinkan Ketua RT untuk memproses permintaan surat yang diajukan oleh warga. Ketua RT dapat melihat daftar pengajuan, memverifikasi, serta mengubah status surat menjadi diproses atau selesai, sehingga proses administrasi menjadi lebih cepat dan terpantau.

### 3. Kelola Kalender Kegiatan

Ketua RT dapat membuat dan mengatur jadwal kegiatan lingkungan. Informasi kegiatan yang ditambahkan akan langsung dapat diakses oleh warga, sehingga memudahkan koordinasi dan penyampaian informasi.

### 4. Kelola Dana Kas RT

Melalui fitur ini, Ketua RT dapat mencatat setiap pemasukan dan pengeluaran kas RT. Hal ini membantu dalam pengelolaan keuangan yang lebih rapi serta mendukung transparansi kepada warga.

### 5. Kelola Pengumuman

Ketua RT dapat membuat, mengubah, dan menyampaikan pengumuman penting kepada seluruh warga. Informasi yang disampaikan menjadi lebih cepat diterima dan tidak bergantung pada metode manual.

### 6. Login dan Logout

Fitur logout digunakan untuk keluar dari sistem guna menjaga keamanan akun. Hal ini penting agar akses ke sistem tetap aman dan hanya digunakan oleh pihak yang berwenang.

## Fitur Warga

### 1. Lihat Kalender Kegiatan

Warga dapat melihat jadwal kegiatan yang telah dibuat oleh Ketua RT. Dengan fitur ini, warga dapat mengetahui informasi kegiatan secara langsung dan tidak ketinggalan agenda lingkungan.

### 2. Lihat Transparansi Dana

Warga dapat mengakses informasi terkait pemasukan dan pengeluaran dana kas RT. Hal ini memberikan transparansi sehingga warga dapat mengetahui kondisi keuangan lingkungan secara terbuka.

### 3. Ajukan Surat

Warga dapat mengajukan permintaan surat pengantar secara online tanpa harus datang langsung. Proses ini membuat pelayanan menjadi lebih praktis dan efisien.

### 4. Cek Status Penduduk

Warga dapat melihat data dan status dirinya yang tersimpan dalam sistem. Fitur ini membantu memastikan bahwa data yang dimiliki oleh RT sudah benar dan sesuai.

### 5. Lihat Pengumuman RT

Warga dapat membaca berbagai pengumuman penting yang disampaikan oleh Ketua RT, seperti informasi kegiatan, kebijakan, atau pemberitahuan lainnya.

### 6. Login dan Logout

Fitur logout digunakan untuk keluar dari sistem setelah selesai digunakan, sehingga keamanan akun tetap terjaga.

# Widget yang Digunakan

1. Widget pada Entry Point
   - ```GetMaterialApp``` digunakan pada main.dart sebagai root aplikasi untuk mengatur navigasi dan state management menggunakan GetX.
   - ```ThemeData``` digunakan pada app_theme.dart untuk mengatur tampilan global seperti warna dan font.
   - ```GetPage``` digunakan pada app_routes.dart untuk menghubungkan setiap halaman (view) dengan binding dan route.
     
2. Widget pada Halaman Dashboard (Admin & Warga)

    Digunakan di: ```admin_dashboard_view.dart``` dan ```warga_dashboard_view.dart```.
   - ```Scaffold``` digunakan sebagai struktur utama halaman dashboard.
   - ```AppBar``` digunakan untuk menampilkan judul dashboard.
   - ```Column``` dan ```Row``` digunakan untuk menyusun layout statistik dan menu.
   - ```Expanded``` digunakan untuk membagi ruang antar komponen dashboard.
   - ```Obx``` digunakan untuk menampilkan data statistik yang berubah secara realtime dari controller.
   - ```Card``` digunakan untuk menampilkan ringkasan data seperti jumlah warga, kegiatan, atau keuangan.
   - ```FlChart``` (BarChart/LineChart) digunakan untuk menampilkan grafik data keuangan atau statistik.
   
4. Widget pada Halaman Kegiatan
   - ```ListView.builder``` digunakan untuk menampilkan daftar kegiatan dari database.
   - ```Card``` digunakan untuk membungkus setiap item kegiatan.
   - ```Text``` digunakan untuk menampilkan judul dan deskripsi kegiatan.
   - ```Obx``` digunakan untuk filter data kegiatan (upcoming, ongoing, selesai).
   - ```Container``` digunakan untuk styling tiap item kegiatan.
     
5. Widget pada Halaman Pengumuman

    Digunakan di: ```admin_announcement_view.dart``` dan ```announcement_view.dart```.
   - ```ListView``` digunakan untuk menampilkan daftar pengumuman.
   - ```Card``` digunakan untuk menampilkan isi pengumuman.
   - ```TextFormField``` digunakan untuk input pengumuman (admin).
   - ```Form``` digunakan untuk validasi input pengumuman.
   - ```Obx``` digunakan untuk update daftar pengumuman secara realtime.
     
6. Widget pada Halaman Keuangan

    Digunakan di: ```admin_finance_view.dart``` dan ```warga_finance_view.dart```.
   - ```ListView.builder``` digunakan untuk menampilkan transaksi keuangan.
   - ```Card``` digunakan untuk setiap item pemasukan/pengeluaran.
   - ```DropdownButton``` digunakan untuk memilih jenis transaksi.
   - ```TextField``` digunakan untuk input nominal.
   - ```Obx``` digunakan untuk memperbarui total keuangan secara realtime.
     
7. Widget pada Halaman Surat

    Digunakan di: ```admin_letters_view.dart``` dan ```letter_view.dart```.
   - ```ListView.builder``` digunakan untuk menampilkan daftar surat.
   - ```Card``` digunakan untuk menampilkan informasi surat.
   - ```TextFormField``` digunakan untuk input pengajuan surat.
   - ```Form``` digunakan untuk validasi data surat.
   - ```Obx``` digunakan untuk menampilkan status surat secara dinamis.
     
8. Widget pada Halaman Data Warga
   - ```ListView.builder``` digunakan untuk menampilkan data penduduk.
   - ```Card``` digunakan untuk menampilkan informasi warga.
   - ```Text``` digunakan untuk menampilkan nama, alamat, dll.
   - ```Obx``` digunakan untuk update data secara realtime.
     
9. Widget pada Halaman Kalender
   - ```TableCalendar``` digunakan untuk menampilkan kalender kegiatan.
   - ```Obx``` digunakan untuk menampilkan event berdasarkan tanggal yang dipilih.
   - ```Container``` digunakan untuk menampilkan detail kegiatan.
     
10. Widget pada Halaman Notifikasi

   Digunakan di: ```admin_notification_view.dart``` dan ```warga_notification_view.dart```.
    - ```ListView.builder``` digunakan untuk daftar notifikasi.
    - ```ListTile``` digunakan untuk menampilkan notifikasi sederhana.
    - ```Obx``` digunakan untuk memperbarui notifikasi secara realtime.
      
11. Widget pada Halaman Profil

     Digunakan di: ```admin_profile_view.dart``` dan ```warga_profile_view.dart```.
    - ```Column``` digunakan untuk menyusun data profil.
    - ```Text``` digunakan untuk menampilkan informasi pengguna.
    - ```TextField``` digunakan untuk edit profil.
    - ```Obx``` digunakan untuk menampilkan data profil secara dinamis.

12. Custom Widget yang Digunakan
    - ```Stack``` digunakan untuk menumpuk background dan konten.
    - ```Container``` dan ```DecorationImage``` digunakan untuk menampilkan gambar latar.
    - ```ClipRRect``` digunakan untuk membuat sudut membulat.
    - ```BackdropFilter``` dan ```ImageFilter.blur``` digunakan untuk efek kaca (glassmorphism).
    - ```Container``` digunakan sebagai wadah isi.
    - ```Container``` dan ```BoxDecoration``` digunakan untuk membuat tombol dengan efek gradient.
    - ```GestureDetector``` digunakan untuk menangani klik tombol.
    - ```CachedNetworkImage``` digunakan untuk menampilkan gambar dari internet.
    - ```Shimmer``` digunakan untuk efek loading gambar.

13. Widget Pendukung dari Library
    - ```CachedNetworkImage``` untuk menampilkan gambar dari URL dengan cache.
    - ```Shimmer``` → efek loading.
    - ```FancyShimmerImage``` → kombinasi gambar + loading.
    - ```FlChart``` → grafik data.
    - ```TableCalendar``` → kalender.
   
14. Komponen Non-Widget
    - Controller (GetxController) digunakan untuk mengatur state dan logika aplikasi.
    - Binding digunakan untuk menghubungkan controller dengan view.
    - Repository digunakan untuk mengambil dan mengelola data dari Supabase.
    - Provider digunakan untuk koneksi ke backend dan storage.
    - Model digunakan untuk struktur data aplikasi.
   
# Package yang Digunakan

1. Core Framework
   - flutter digunakan sebagai framework utama untuk membangun aplikasi mobile berbasis widget, seperti Scaffold, Container, dan ListView.
2. State Management & Navigasi
   - get (GetX) digunakan untuk mengelola state aplikasi, navigasi antar halaman, serta dependency injection. Pada project ini digunakan melalui Obx, GetMaterialApp, GetPage, dan Binding–Controller.
3. Backend & Database
   - supabase_flutter digunakan sebagai backend untuk autentikasi pengguna, pengelolaan database PostgreSQL, dan penyimpanan data. Digunakan pada layer repository.
   - flutter_dotenv digunakan untuk membaca file .env yang berisi konfigurasi seperti URL dan API Key Supabase.
4. UI & Tampilan
   - google_fonts digunakan untuk mengatur jenis font agar tampilan aplikasi lebih menarik.
   - cached_network_image digunakan untuk menampilkan gambar dari internet dengan sistem cache agar lebih efisien.
   - shimmer digunakan untuk memberikan efek loading (skeleton screen) saat data sedang dimuat.
   - fancy_shimmer_image digunakan untuk menampilkan gambar dengan efek loading yang lebih praktis.
5. Visualisasi & Kalender
   - fl_chart digunakan untuk menampilkan grafik seperti diagram batang atau garis pada dashboard.
   - table_calendar digunakan untuk menampilkan kalender interaktif pada fitur kegiatan.
6. Format & Utility
   - intl digunakan untuk format tanggal, angka, dan mata uang.
   - uuid digunakan untuk membuat ID unik pada data.
   - equatable digunakan untuk mempermudah perbandingan object pada model data.
7. File & Media
   - image_picker digunakan untuk mengambil gambar dari kamera atau galeri.
   - file_picker digunakan untuk memilih file seperti PDF atau dokumen.
   - path_provider digunakan untuk mengakses direktori penyimpanan lokal perangkat.
8. Integrasi Device
   - url_launcher digunakan untuk membuka link, browser, atau aplikasi lain seperti WhatsApp.
   - share_plus digunakan untuk membagikan konten ke aplikasi lain.
9. Notifikasi & Keamanan
   - flutter_local_notifications digunakan untuk menampilkan notifikasi lokal pada perangkat.
   - flutter_secure_storage digunakan untuk menyimpan data sensitif seperti token secara aman.
10. Tampilan Tambahan
    - cupertino_icons digunakan untuk menyediakan ikon bergaya iOS.
    - flutter_native_splash digunakan untuk membuat tampilan splash screen saat aplikasi pertama kali dibuka.
