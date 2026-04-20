import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> login(
    String nik,
    String password,
    DateTime tanggalLahir,
  ) async {
    try {
      // Format tanggal ke YYYY-MM-DD sesuai tipe 'date' di PostgreSQL
      final tglFormatted =
          '${tanggalLahir.year.toString().padLeft(4, '0')}-'
          '${tanggalLahir.month.toString().padLeft(2, '0')}-'
          '${tanggalLahir.day.toString().padLeft(2, '0')}';

      // Query: match NIK + password + tanggal lahir
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
      final isAdmin = response['role'] == 'admin';

      return {'success': true, 'penduduk': penduduk, 'isAdmin': isAdmin};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
