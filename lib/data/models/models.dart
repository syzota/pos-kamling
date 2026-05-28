import 'package:equatable/equatable.dart';

class PenggunaModel extends Equatable {
  final int? idPengguna;
  final int? idPenduduk;
  final String username;
  final String? password;
  final String role; 

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
  final String? alamat;
  final String? nomorTelepon;
  final String? fotoUrl;
  final String? fcmToken;

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
    this.alamat,
    this.nomorTelepon,
    this.fotoUrl,
    this.fcmToken,
  });

  String get inisialNama {
    final n = (nama ?? '').trim();
    if (n.isEmpty) return '?';
    final parts = n.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  int? get umurDihitung {
    if (umur != null) return umur;
    if (tanggalLahir == null) return null;
    final now = DateTime.now();
    var age = now.year - tanggalLahir!.year;
    if (now.month < tanggalLahir!.month ||
        (now.month == tanggalLahir!.month && now.day < tanggalLahir!.day)) {
      age--;
    }
    return age;
  }

  factory PendudukModel.fromJson(Map<String, dynamic> json) {
    return PendudukModel(
      idPenduduk: json['id_penduduk'],
      nik: json['nik']?.toString(),
      nama: json['nama']?.toString(),
      tempatLahir: json['tempat_lahir']?.toString(),
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse(json['tanggal_lahir'].toString())
          : null,
      umur: json['umur'] is int
          ? json['umur']
          : int.tryParse(json['umur']?.toString() ?? ''),
      jenisKelamin: json['jenis_kelamin']?.toString(),
      statusPerkawinan: json['status_perkawinan']?.toString(),
      agama: json['agama']?.toString(),
      golonganDarah: json['golongan_darah']?.toString(),
      pendidikanTerakhir: json['pendidikan_terakhir']?.toString(),
      pekerjaan: json['pekerjaan']?.toString(),
      namaAyahIbu: json['nama_ayah_ibu']?.toString(),
      disabilitas: json['disabilitas']?.toString(),
      password: json['password']?.toString(),
      alamat: json['alamat']?.toString(),
      nomorTelepon: json['nomor_telepon']?.toString(),
      fotoUrl: json['foto_url']?.toString(),
      fcmToken: json['fcm_token']?.toString(),
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
        if (pendidikanTerakhir != null)
          'pendidikan_terakhir': pendidikanTerakhir,
        if (pekerjaan != null) 'pekerjaan': pekerjaan,
        if (namaAyahIbu != null) 'nama_ayah_ibu': namaAyahIbu,
        if (disabilitas != null) 'disabilitas': disabilitas,
        if (password != null) 'password': password,
        if (alamat != null) 'alamat': alamat,
        if (nomorTelepon != null) 'nomor_telepon': nomorTelepon,
        if (fotoUrl != null) 'foto_url': fotoUrl,
        if (fcmToken != null) 'fcm_token': fcmToken,
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
    String? alamat,
    String? nomorTelepon,
    String? fotoUrl,
    String? fcmToken,
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
      alamat: alamat ?? this.alamat,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [
    idPenduduk,
    nik,
    nama,
    tempatLahir,
    tanggalLahir,
    umur,
    jenisKelamin,
    statusPerkawinan,
    agama,
    golonganDarah,
    pendidikanTerakhir,
    pekerjaan,
    namaAyahIbu,
    disabilitas,
    alamat,
    nomorTelepon,
    fotoUrl,
    fcmToken,
  ];
}

class KegiatanModel extends Equatable {
  final int? idKegiatan;
  final String? namaKegiatan;
  final String? jenisKegiatan;
  final DateTime? tanggal;
  final String? waktu;
  final String? lokasi;
  final String? deskripsi;
  final String? foto;
  final double? latitude;
  final double? longitude;

  const KegiatanModel({
    this.idKegiatan,
    this.namaKegiatan,
    this.jenisKegiatan,
    this.tanggal,
    this.waktu,
    this.lokasi,
    this.deskripsi,
    this.foto,
    this.latitude,
    this.longitude,
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
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (idKegiatan != null) 'id_kegiatan': idKegiatan,
        if (namaKegiatan != null) 'nama_kegiatan': namaKegiatan,
        if (jenisKegiatan != null) 'jenis_kegiatan': jenisKegiatan,
        if (tanggal != null)
          'tanggal': tanggal!.toIso8601String().split('T').first,
        if (waktu != null) 'waktu': waktu,
        if (lokasi != null) 'lokasi': lokasi,
        if (deskripsi != null) 'deskripsi': deskripsi,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

  @override
  List<Object?> get props => [
        idKegiatan,
        namaKegiatan,
        tanggal,
        latitude,
        longitude,
      ];
}

class SuratModel extends Equatable {
  final int? idSurat;
  final int? idPenduduk;
  final String? jenisSurat;
  final String? keperluan;
  final String status;
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

class KeuanganModel extends Equatable {
  final int? idKeuangan;
  final String? jenis;
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
        if (tanggal != null)
          'tanggal': tanggal!.toIso8601String().split('T').first,
      };

  @override
  List<Object?> get props => [idKeuangan, jenis, nominal, tanggal];
}

class PengumumanModel extends Equatable {
  final int? idPengumuman;
  final String? judul;
  final String? isi;
  final String? kategori;
  final String? deskripsi;
  final String? imageUrl;
  final DateTime? createdAt;

  const PengumumanModel({
    this.idPengumuman,
    this.judul,
    this.isi,
    this.kategori,
    this.deskripsi,
    this.imageUrl,
    this.createdAt,
  });

  factory PengumumanModel.fromJson(Map<String, dynamic> json) {
    return PengumumanModel(
      idPengumuman: json['id_pengumuman'],
      judul: json['judul']?.toString(),
      isi: json['isi']?.toString(),
      kategori: json['kategori']?.toString(),
      deskripsi: json['deskripsi']?.toString(),
      imageUrl: json['image_url']?.toString(),
      createdAt: json['tanggal'] == null
          ? null
          : DateTime.tryParse(json['tanggal'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (idPengumuman != null) 'id_pengumuman': idPengumuman,
        if (judul != null) 'judul': judul,
        if (isi != null) 'isi': isi,
        if (kategori != null) 'kategori': kategori,
        if (deskripsi != null) 'deskripsi': deskripsi,
        if (imageUrl != null) 'image_url': imageUrl,
        if (createdAt != null) 'tanggal': createdAt!.toIso8601String(),
      };

  @override
  List<Object?> get props => [idPengumuman, judul, createdAt];
}

class NotifikasiModel extends Equatable {
  final int? idNotifikasi;
  final int? idPenduduk;
  final String? judul;
  final String? isi;
  final String? tipe;
  final bool isRead;
  final DateTime? createdAt;
  final Map<String, dynamic>? data;

  const NotifikasiModel({
    this.idNotifikasi,
    this.idPenduduk,
    this.judul,
    this.isi,
    this.tipe,
    this.isRead = false,
    this.createdAt,
    this.data,
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
      data: json['data'] is Map<String, dynamic>
          ? json['data']
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
        if (data != null) 'data': data,
      };

  @override
  List<Object?> get props => [idNotifikasi, idPenduduk, judul, createdAt];
}