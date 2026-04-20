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

## Struktur Library

# Fitur Aplikasi

## Fitur Login dan Logout

### 1. Login Admin (Ketua RT)

Fitur login admin digunakan oleh Ketua RT untuk masuk ke dalam sistem menggunakan akun yang telah terdaftar. Ketua RT memasukkan data seperti NIK, password, dan informasi pendukung lainnya yang sudah tersimpan di database. Sistem akan melakukan proses autentikasi untuk memastikan bahwa data yang dimasukkan sesuai. Jika berhasil, admin akan diarahkan ke halaman dashboard khusus yang memiliki akses penuh untuk mengelola data penduduk, surat, keuangan, kegiatan, dan pengumuman.

### 2. Login Warga

Fitur login warga digunakan oleh masyarakat untuk mengakses aplikasi sesuai dengan hak aksesnya. Warga memasukkan data login seperti NIK dan password, kemudian sistem akan memverifikasi data tersebut. Setelah berhasil login, warga akan diarahkan ke halaman utama yang berisi fitur seperti melihat pengumuman, mengajukan surat, melihat kegiatan, dan memantau transparansi dana. Hak akses warga lebih terbatas dibandingkan admin agar keamanan data tetap terjaga.

### 3. Sistem Autentikasi dan Hak Akses

Pada saat proses login, sistem tidak hanya memverifikasi data pengguna, tetapi juga menentukan peran pengguna (admin atau warga). Berdasarkan peran tersebut, sistem akan mengarahkan pengguna ke tampilan dan fitur yang sesuai. Dengan adanya pembagian hak akses ini, setiap pengguna hanya dapat mengakses fitur yang diperbolehkan, sehingga keamanan dan pengelolaan sistem menjadi lebih terkontrol.

### 4. Logout (Keluar dari Sistem)

Fitur logout digunakan oleh admin maupun warga untuk keluar dari aplikasi. Ketika pengguna melakukan logout, sistem akan menghapus sesi login yang sedang aktif sehingga pengguna harus melakukan login kembali untuk mengakses aplikasi. Hal ini penting untuk menjaga keamanan akun, terutama jika aplikasi digunakan pada perangkat bersama.

## Fitur Ketua RT (Admin)

### 1. Kelola Data Penduduk

Fitur ini digunakan oleh Ketua RT untuk mengelola seluruh data warga dalam satu sistem terpusat. Melalui fitur ini, Ketua RT dapat menambahkan data penduduk baru, memperbarui informasi yang sudah ada, serta memastikan setiap data tersimpan dengan rapi dan akurat. Dengan adanya sistem digital, proses pencarian dan pengelolaan data menjadi lebih mudah dibandingkan pencatatan manual.

### 2. Kelola Surat Pengantar

Fitur ini berfungsi untuk mempermudah proses administrasi surat antara warga dan Ketua RT. Warga dapat mengajukan permohonan surat melalui aplikasi, kemudian Ketua RT dapat memeriksa dan memverifikasi pengajuan tersebut. Selain itu, Ketua RT juga dapat mengubah status surat, seperti diproses atau selesai, sehingga seluruh proses menjadi lebih cepat, transparan, dan terpantau.

### 3. Kelola Kalender Kegiatan

Fitur ini memungkinkan Ketua RT untuk membuat dan mengatur jadwal kegiatan di lingkungan RT. Informasi kegiatan yang ditambahkan akan langsung tersedia dalam aplikasi dan dapat diakses oleh warga. Dengan demikian, warga dapat mengetahui jadwal kegiatan dengan lebih mudah, sehingga koordinasi dan partisipasi dalam kegiatan lingkungan menjadi lebih baik.

### 4. Kelola Dana Kas RT

Fitur ini digunakan untuk mencatat dan mengelola keuangan kas RT secara digital. Ketua RT dapat mencatat setiap pemasukan dan pengeluaran dengan lebih terstruktur. Data keuangan yang tersimpan dapat dipantau kembali kapan saja, sehingga membantu menjaga transparansi dan akuntabilitas dalam pengelolaan dana kepada seluruh warga.

### 5. Kelola Pengumuman

Fitur ini digunakan untuk menyampaikan informasi penting kepada warga secara cepat dan efisien. Ketua RT dapat membuat, mengubah, dan menghapus pengumuman sesuai kebutuhan. Informasi yang disampaikan akan langsung ditampilkan di aplikasi warga, sehingga penyampaian informasi menjadi lebih praktis dan tidak bergantung pada metode manual.

## Fitur Warga

### 1. Lihat Kalender Kegiatan

Fitur ini memungkinkan warga untuk melihat jadwal kegiatan yang telah dibuat oleh Ketua RT melalui aplikasi. Informasi seperti tanggal, jenis kegiatan, dan detail acara dapat diakses dengan mudah. Dengan adanya fitur ini, warga tidak akan ketinggalan informasi terkait kegiatan lingkungan dan dapat mempersiapkan diri untuk berpartisipasi.

### 2. Lihat Transparansi Dana

Fitur ini memberikan akses kepada warga untuk melihat laporan keuangan kas RT, baik pemasukan maupun pengeluaran. Setiap transaksi dicatat secara sistematis sehingga warga dapat mengetahui kondisi keuangan lingkungan secara terbuka. Hal ini bertujuan untuk meningkatkan kepercayaan dan transparansi dalam pengelolaan dana.

### 3. Ajukan Surat

Melalui fitur ini, warga dapat mengajukan permohonan surat pengantar secara online tanpa perlu datang langsung ke Ketua RT. Warga hanya perlu mengisi data yang dibutuhkan melalui aplikasi. Setelah itu, pengajuan akan diproses oleh Ketua RT. Fitur ini membuat proses administrasi menjadi lebih praktis, cepat, dan efisien.

### 4. Cek Status Penduduk

Fitur ini memungkinkan warga untuk melihat data pribadi yang tersimpan dalam sistem, seperti identitas dan status kependudukan. Dengan adanya fitur ini, warga dapat memastikan bahwa data yang dimiliki oleh Ketua RT sudah benar dan sesuai. Jika terdapat kesalahan, warga dapat segera melakukan pembaruan data.

### 5. Lihat Pengumuman RT

Fitur ini digunakan untuk menampilkan berbagai pengumuman penting yang disampaikan oleh Ketua RT kepada warga. Informasi seperti kegiatan, kebijakan, atau pemberitahuan lainnya dapat langsung diakses melalui aplikasi. Dengan demikian, penyampaian informasi menjadi lebih cepat dan tidak terlewat oleh warga.

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
