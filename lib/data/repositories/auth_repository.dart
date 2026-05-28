import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;

  Future<PendudukModel?> getPendudukByNik(String nik) async {
    try {
      final response = await supabase
          .from('penduduk')
          .select()
          .eq('nik', nik)
          .maybeSingle();

      if (response == null) return null;

      return PendudukModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> login(
    String nik,
    String password,
    DateTime tanggalLahir,
  ) async {
    try {
      final tglFormatted =
          '${tanggalLahir.year.toString().padLeft(4, '0')}-'
          '${tanggalLahir.month.toString().padLeft(2, '0')}-'
          '${tanggalLahir.day.toString().padLeft(2, '0')}';

      final response = await supabase
          .from('penduduk')
          .select()
          .eq('nik', nik)
          .eq('password', password)
          .eq('tanggal_lahir', tglFormatted)
          .maybeSingle();

      if (response == null) {
        return {
          'success': false,
          'message':
              'Data tidak cocok. Pastikan NIK, tanggal lahir, dan password benar.',
        };
      }

      final penduduk = PendudukModel.fromJson(response);

      final role = response['role']?.toString() ?? 'warga';

      final isAdmin = role == 'admin';

      return {
        'success': true,
        'penduduk': penduduk,
        'isAdmin': isAdmin,
        'role': role,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}