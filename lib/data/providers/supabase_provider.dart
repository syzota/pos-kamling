import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  }

  // Auth helpers
  static User? get currentUser => client.auth.currentUser;
  static Session? get currentSession => client.auth.currentSession;
  static bool get isLoggedIn => currentUser != null;

  // Table references
  static SupabaseQueryBuilder get pendudukTable => client.from('penduduk');
  static SupabaseQueryBuilder get penggunaTable => client.from('pengguna');
  static SupabaseQueryBuilder get kegiatanTable => client.from('kegiatan');
  static SupabaseQueryBuilder get suratTable => client.from('surat');
  static SupabaseQueryBuilder get keuanganTable => client.from('keuangan');
  static SupabaseQueryBuilder get pengumumanTable => client.from('pengumuman');
  static SupabaseQueryBuilder get kartuKeluargaTable => client.from('kartu_keluarga');
  static SupabaseQueryBuilder get notifikasiTable => client.from('notifikasi');
}