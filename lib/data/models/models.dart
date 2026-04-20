import 'package:equatable/equatable.dart';

// ==================== PENGGUNA MODEL ====================
class PenggunaModel extends Equatable {
  final int? idPengguna;
  final int? idPenduduk;
  final String username;
  final String? password;
  final String role; // 'admin' | 'warga'

  const PenggunaModel({
    this.idPengguna,
    this.idPenduduk,
    required this.username,
    this.password,
    required this.role,
  });

  bool get isAdmin => role == 'admin';

  factory PenggunaModel.fromJson(Map<String, dynamic> json) {
    return PenggunaModel(
      idPengguna: json['id_pengguna'],
      idPenduduk: json['id_penduduk'],
      username: json['username'] ?? '',
      role: json['role'] ?? 'warga',
    );
  }

  Map<String, dynamic> toJson() => {
    if (idPengguna != null) 'id_pengguna': idPengguna,
    if (idPenduduk != null) 'id_penduduk': idPenduduk,
    'username': username,
    if (password != null) 'password': password,
    'role': role,
  };

  @override
  List<Object?> get props => [idPengguna, username, role];
}

// ==================== PENDUDUK MODEL ====================
class PendudukModel extends Equatable {
  final int? idPenduduk;
  final String? nik;
  final String? nama;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final int? umur;
  final String? jenisKelamin;
  final String? statusPerkawinan;
  final String? agama;
  final String? golonganDarah;
  final String? pendidikanTerakhir;
  final String? pekerjaan;
  final String? namaAyahIbu;
  final String? disabilitas;
  final String? password;

  const PendudukModel({
    this.idPenduduk,
    this.nik,
    this.nama,
    this.tempatLahir,
    this.tanggalLahir,
    this.umur,
    this.jenisKelamin,
    this.statusPerkawinan,
    this.agama,
    this.golonganDarah,
    this.pendidikanTerakhir,
    this.pekerjaan,
    this.namaAyahIbu,
    this.disabilitas,
    this.password,
  });

  factory PendudukModel.fromJson(Map<String, dynamic> json) {
    return PendudukModel(
      idPenduduk: json['id_penduduk'],
      nik: json['nik'],
      nama: json['nama'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse(json['tanggal_lahir'])
          : null,
      umur: json['umur'],
      jenisKelamin: json['jenis_kelamin'],
      statusPerkawinan: json['status_perkawinan'],
      agama: json['agama'],
      golonganDarah: json['golongan_darah'],
      pendidikanTerakhir: json['pendidikan_terakhir'],
      pekerjaan: json['pekerjaan'],
      namaAyahIbu: json['nama_ayah_ibu'],
      disabilitas: json['disabilitas'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (idPenduduk != null) 'id_penduduk': idPenduduk,
    if (nik != null) 'nik': nik,
    if (nama != null) 'nama': nama,
    if (tempatLahir != null) 'tempat_lahir': tempatLahir,
    if (tanggalLahir != null)
      'tanggal_lahir': tanggalLahir!.toIso8601String().split('T').first,
    if (umur != null) 'umur': umur,
    if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
    if (statusPerkawinan != null) 'status_perkawinan': statusPerkawinan,
    if (agama != null) 'agama': agama,
    if (golonganDarah != null) 'golongan_darah': golonganDarah,
    if (pendidikanTerakhir != null) 'pendidikan_terakhir': pendidikanTerakhir,
    if (pekerjaan != null) 'pekerjaan': pekerjaan,
    if (namaAyahIbu != null) 'nama_ayah_ibu': namaAyahIbu,
    if (disabilitas != null) 'disabilitas': disabilitas,
    if (password != null) 'password': password,
  };

  PendudukModel copyWith({
    int? idPenduduk,
    String? nik,
    String? nama,
    String? tempatLahir,
    DateTime? tanggalLahir,
    int? umur,
    String? jenisKelamin,
    String? statusPerkawinan,
    String? agama,
    String? golonganDarah,
    String? pendidikanTerakhir,
    String? pekerjaan,
    String? namaAyahIbu,
    String? disabilitas,
    String? password,
  }) {
    return PendudukModel(
      idPenduduk: idPenduduk ?? this.idPenduduk,
      nik: nik ?? this.nik,
      nama: nama ?? this.nama,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      umur: umur ?? this.umur,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      statusPerkawinan: statusPerkawinan ?? this.statusPerkawinan,
      agama: agama ?? this.agama,
      golonganDarah: golonganDarah ?? this.golonganDarah,
      pendidikanTerakhir: pendidikanTerakhir ?? this.pendidikanTerakhir,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      namaAyahIbu: namaAyahIbu ?? this.namaAyahIbu,
      disabilitas: disabilitas ?? this.disabilitas,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [idPenduduk, nik, nama];
}

// ==================== KEGIATAN MODEL ====================
class KegiatanModel extends Equatable {
  final int? idKegiatan;
  final String? namaKegiatan;
  final String? jenisKegiatan;
  final DateTime? tanggal;
  final String? waktu;
  final String? lokasi;
  final String? deskripsi;
  final String? foto;

  const KegiatanModel({
    this.idKegiatan,
    this.namaKegiatan,
    this.jenisKegiatan,
    this.tanggal,
    this.waktu,
    this.lokasi,
    this.deskripsi,
    this.foto,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      idKegiatan: json['id_kegiatan'],
      namaKegiatan: json['nama_kegiatan'],
      jenisKegiatan: json['jenis_kegiatan'],
      tanggal: json['tanggal'] != null
          ? DateTime.tryParse(json['tanggal'])
          : null,
      waktu: json['waktu'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (idKegiatan != null) 'id_kegiatan': idKegiatan,
    if (namaKegiatan != null) 'nama_kegiatan': namaKegiatan,
    if (jenisKegiatan != null) 'jenis_kegiatan': jenisKegiatan,
    if (tanggal != null) 'tanggal': tanggal!.toIso8601String().split('T').first,
    if (waktu != null) 'waktu': waktu,
    if (lokasi != null) 'lokasi': lokasi,
    if (deskripsi != null) 'deskripsi': deskripsi,
  };

  @override
  List<Object?> get props => [idKegiatan, namaKegiatan, tanggal];
}

// ==================== SURAT MODEL ====================
class SuratModel extends Equatable {
  final int? idSurat;
  final int? idPenduduk;
  final String? jenisSurat;
  final String? keperluan;
  final String status; // 'diajukan' | 'diproses' | 'disetujui' | 'ditolak'
  final DateTime? tanggalPengajuan;
  final DateTime? tanggalSelesai;
  final PendudukModel? penduduk;
  final String? fileUrl;

  const SuratModel({
    this.idSurat,
    this.idPenduduk,
    this.jenisSurat,
    this.keperluan,
    this.status = 'diajukan',
    this.tanggalPengajuan,
    this.tanggalSelesai,
    this.penduduk,
    this.fileUrl,
  });

  factory SuratModel.fromJson(Map<String, dynamic> json) {
    return SuratModel(
      idSurat: json['id_surat'],
      idPenduduk: json['id_penduduk'],
      jenisSurat: json['jenis_surat'],
      keperluan: json['keperluan'],
      status: json['status'] ?? 'diajukan',
      tanggalPengajuan: json['tanggal_pengajuan'] != null
          ? DateTime.tryParse(json['tanggal_pengajuan'])
          : null,
      tanggalSelesai: json['tanggal_selesai'] != null
          ? DateTime.tryParse(json['tanggal_selesai'])
          : null,
      penduduk: json['penduduk'] != null
          ? PendudukModel.fromJson(json['penduduk'])
          : null,
      fileUrl: json['file_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (idSurat != null) 'id_surat': idSurat,
    if (idPenduduk != null) 'id_penduduk': idPenduduk,
    if (jenisSurat != null) 'jenis_surat': jenisSurat,
    if (keperluan != null) 'keperluan': keperluan,
    if (fileUrl != null) 'file_url': fileUrl,
    'status': status,
  };

  @override
  List<Object?> get props => [idSurat, jenisSurat, status, fileUrl];
}

// ==================== KEUANGAN MODEL ====================
class KeuanganModel extends Equatable {
  final int? idKeuangan;
  final String? jenis; // 'pemasukan' | 'pengeluaran'
  final double? nominal;
  final String? keterangan;
  final DateTime? tanggal;

  const KeuanganModel({
    this.idKeuangan,
    this.jenis,
    this.nominal,
    this.keterangan,
    this.tanggal,
  });

  bool get isPemasukan => jenis == 'pemasukan';

  factory KeuanganModel.fromJson(Map<String, dynamic> json) {
    return KeuanganModel(
      idKeuangan: json['id_keuangan'],
      jenis: json['jenis'],
      nominal: (json['nominal'] as num?)?.toDouble(),
      keterangan: json['keterangan'],
      tanggal: json['tanggal'] != null
          ? DateTime.tryParse(json['tanggal'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (idKeuangan != null) 'id_keuangan': idKeuangan,
    if (jenis != null) 'jenis': jenis,
    if (nominal != null) 'nominal': nominal,
    if (keterangan != null) 'keterangan': keterangan,
    if (tanggal != null) 'tanggal': tanggal!.toIso8601String().split('T').first,
  };

  @override
  List<Object?> get props => [idKeuangan, jenis, nominal, tanggal];
}

// ==================== PENGUMUMAN MODEL ====================
class PengumumanModel extends Equatable {
  final int? idPengumuman;
  final String? judul;
  final String? isi;
  final String? kategori;
  final DateTime? createdAt;
  final String? deskripsi;
  final String? imageUrl;

  const PengumumanModel({
    this.idPengumuman,
    this.judul,
    this.isi,
    this.kategori,
    this.createdAt,
    this.deskripsi,
    this.imageUrl,
  });

  factory PengumumanModel.fromJson(Map<String, dynamic> json) {
    return PengumumanModel(
      idPengumuman: json['id_pengumuman'],
      judul: json['judul'],
      isi: json['isi'],
      kategori: json['kategori'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (idPengumuman != null) 'id_pengumuman': idPengumuman,
    if (judul != null) 'judul': judul,
    if (isi != null) 'isi': isi,
    if (kategori != null) 'kategori': kategori,
    if (deskripsi != null) 'deskripsi': deskripsi,
    if (createdAt != null) 'createdAt': createdAt,
  };

  @override
  List<Object?> get props => [idPengumuman, judul, createdAt];
}

// ==================== NOTIFIKASI MODEL ====================
class NotifikasiModel extends Equatable {
  final int? idNotifikasi;
  final int? idPenduduk;
  final String? judul;
  final String? isi;
  final String? tipe;
  final bool isRead;
  final DateTime? createdAt;

  const NotifikasiModel({
    this.idNotifikasi,
    this.idPenduduk,
    this.judul,
    this.isi,
    this.tipe,
    this.isRead = false,
    this.createdAt,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      idNotifikasi: json['id_notifikasi'],
      idPenduduk: json['id_penduduk'],
      judul: json['judul'],
      isi: json['isi'],
      tipe: json['tipe'],
      isRead: json['is_read'] == true || json['is_read'] == 'true',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (idNotifikasi != null) 'id_notifikasi': idNotifikasi,
    if (idPenduduk != null) 'id_penduduk': idPenduduk,
    if (judul != null) 'judul': judul,
    if (isi != null) 'isi': isi,
    if (tipe != null) 'tipe': tipe,
    'is_read': isRead,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
  };

  @override
  List<Object?> get props => [idNotifikasi, idPenduduk, judul, createdAt];
}
