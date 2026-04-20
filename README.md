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

1. Widget Utama (Struktur Halaman)
   - Scaffold digunakan sebagai kerangka utama halaman untuk menampilkan AppBar, body, dan komponen lainnya.
   - AppBar digunakan sebagai bagian header untuk menampilkan judul halaman dan navigasi.
   - SafeArea digunakan agar tampilan tidak tertutup oleh notch atau sistem UI perangkat.
   - Container digunakan sebagai wadah utama untuk menampung dan mengatur tampilan komponen.
   - Padding dan SizedBox digunakan untuk mengatur jarak antar elemen.
   - Column dan Row digunakan untuk menyusun layout secara vertikal dan horizontal.
   - Expanded dan Flexible digunakan untuk mengatur pembagian ruang secara responsif.
   
2. Widget Penampil Data
   - ListView digunakan untuk menampilkan data dalam bentuk daftar.
   - ListView.builder digunakan untuk menampilkan data secara dinamis dari database.
   - Card digunakan sebagai pembungkus item agar tampil lebih rapi dan terstruktur.
   - ListTile digunakan untuk menampilkan informasi sederhana seperti judul dan subtitle dalam list.
     
3. Widget Reactive (GetX)
6. Widget Input dan Form
7. Widget Navigasi (GetX)
8. Widget Tampilan Lanjutan (UI Enhancement)
9. Custom Widget
10. Widget/Komponen Notifikasi
11. Komponen Non-Widget (Pendukung)
