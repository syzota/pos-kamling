import '../providers/supabase_provider.dart';
import '../models/models.dart';

class SuratRepository {
  // Warga: get their own surat
  Future<List<SuratModel>> getSuratByPenduduk(int idPenduduk) async {
    final res = await SupabaseProvider.suratTable
        .select()
        .eq('id_penduduk', idPenduduk)
        .order('tanggal_pengajuan', ascending: false);
    return (res as List).map((e) => SuratModel.fromJson(e)).toList();
  }

  // Admin: get all surat with penduduk info
  Future<List<SuratModel>> getAllSurat() async {
    final res = await SupabaseProvider.suratTable
        .select('*, penduduk(id_penduduk, nama, nik)')
        .order('tanggal_pengajuan', ascending: false);
    return (res as List).map((e) => SuratModel.fromJson(e)).toList();
  }

  // Admin: get pending surat
  Future<List<SuratModel>> getPendingSurat() async {
    final res = await SupabaseProvider.suratTable
        .select('*, penduduk(id_penduduk, nama, nik)')
        .eq('status', 'diajukan')
        .order('tanggal_pengajuan', ascending: false);
    return (res as List).map((e) => SuratModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> ajukanSurat({
    required int idPenduduk,
    required String jenisSurat,
    required String keperluan,
  }) async {
    try {
      await SupabaseProvider.suratTable.insert({
        'id_penduduk': idPenduduk,
        'jenis_surat': jenisSurat,
        'keperluan': keperluan,
        'status': 'diajukan',
      });
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateStatusSurat(int idSurat, String status) async {
    try {
      final updateData = {'status': status};
      if (status == 'disetujui' || status == 'ditolak') {
        updateData['tanggal_selesai'] = DateTime.now().toIso8601String();
      }
      await SupabaseProvider.suratTable
          .update(updateData)
          .eq('id_surat', idSurat);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}