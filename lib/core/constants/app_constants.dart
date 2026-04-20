import 'package:flutter/material.dart';

class AppColors {
  // Primary - Pink/Rose
  static const Color primary = Color(0xFFB60059);
  static const Color primaryContainer = Color(0xFFE30071);
  static const Color primaryFixed = Color(0xFFFFD9E1);
  static const Color primaryFixedDim = Color(0xFFFFB1C4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);
  static const Color onPrimaryFixed = Color(0xFF3F001A);
  static const Color onPrimaryFixedVariant = Color(0xFF8F0044);
  static const Color inversePrimary = Color(0xFFFFB1C4);

  // Secondary - Blue Gray
  static const Color secondary = Color(0xFF515F74);
  static const Color secondaryContainer = Color(0xFFD5E3FD);
  static const Color secondaryFixed = Color(0xFFD5E3FD);
  static const Color secondaryFixedDim = Color(0xFFB9C7E0);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF57657B);
  static const Color onSecondaryFixed = Color(0xFF0D1C2F);
  static const Color onSecondaryFixedVariant = Color(0xFF3A485C);

  // Tertiary - Green
  static const Color tertiary = Color(0xFF006B17);
  static const Color tertiaryContainer = Color(0xFF008820);
  static const Color tertiaryFixed = Color(0xFF7FFD7C);
  static const Color tertiaryFixedDim = Color(0xFF63E063);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFF7FFF0);
  static const Color onTertiaryFixed = Color(0xFF002203);
  static const Color onTertiaryFixedVariant = Color(0xFF00530F);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surface
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceBright = Color(0xFFF7F9FB);
  static const Color surfaceDim = Color(0xFFD8DADC);
  static const Color surfaceVariant = Color(0xFFE0E3E5);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFBA005B);
  static const Color inverseSurface = Color(0xFF2D3133);
  static const Color inverseOnSurface = Color(0xFFEFF1F3);

  // Background & On-Surface
  static const Color background = Color(0xFFF7F9FB);
  static const Color onBackground = Color(0xFF191C1E);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF5C3F46);

  // Outline
  static const Color outline = Color(0xFF906E76);
  static const Color outlineVariant = Color(0xFFE5BCC5);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );
}

class AppStrings {
  static const String appName = 'RT-Digital';
  static const String appTagline = 'Sistem Manajemen RT Modern';
  static const String rtName = 'RT 052';
  static const String rtAddress = 'Lingkungan Rukun Tetangga';

  // Auth
  static const String login = 'Masuk';
  static const String register = 'Daftar';
  static const String logout = 'Keluar';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String forgotPassword = 'Lupa Password?';
  static const String noAccount = 'Belum punya akun?';
  static const String hasAccount = 'Sudah punya akun?';
  static const String registerNow = 'Daftar Sekarang';
  static const String loginNow = 'Masuk Sekarang';
  static const String roleWarga = 'Warga';
  static const String rolePakRT = 'Ketua RT';

  // Navigation
  static const String home = 'Home';
  static const String calendar = 'Kalender';
  static const String letters = 'Surat';
  static const String finance = 'Keuangan';
  static const String admin = 'Admin';
  static const String residents = 'Warga';
  static const String activities = 'Kegiatan';
  static const String announcements = 'Pengumuman';

  // Features
  static const String letterRequest = 'Ajukan Surat';
  static const String activityCalendar = 'Kalender Kegiatan';
  static const String financialTransparency = 'Transparansi Kas';
  static const String residentData = 'Data Kependudukan';

  // Surat Types
  static const List<String> suratTypes = [
    'Kartu Keluarga (KK)',
    'Kartu Tanda Penduduk (KTP)',
    'Surat Keterangan Pindah',
    'Surat Keterangan Pindah Datang',
    'Surat Keterangan Pindah Keluar Negeri',
    'Surat Keterangan Pindah Datang dari Luar Negeri',
    'Surat Keterangan Tempat Tinggal / Domisili',
    'Surat Keterangan Kelahiran / Akta Kelahiran',
    'Surat Keterangan Lahir Mati',
    'Surat Keterangan Pembatalan Perkawinan',
    'Surat Keterangan Pembatalan Perceraian',
    'Surat Keterangan Kematian',
    'Surat Keterangan Pengangkatan Anak',
    'Surat Keterangan Pelepasan Kewarganegaraan Indonesia',
    'Surat Keterangan Penggantian Tanda Identitas',
    'Surat Keterangan Catatan Kepolisian (SKCK)',
    'Surat Keterangan Ijin Usaha (SIUP)',
    'Surat Keterangan Belum / Akan Menikah',
    'Surat Keterangan Tidak Mampu (SKTM)',
    'Surat Keterangan Permohonan IMB',
    'Surat Pengantar Kartu Indonesia Sehat (KIS)',
    'Surat Keterangan Kehilangan',
    'Lain-lain',
  ];
}

class AppDimensions {
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  static const double cardElevation = 0.0;
  static const double bottomNavHeight = 80.0;
}