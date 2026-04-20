import '../providers/supabase_provider.dart';
import '../models/models.dart';

class PendudukRepository {
  Future<List<PendudukModel>> getAllPenduduk() async {
    final res = await SupabaseProvider.pendudukTable
        .select()
        .order('nama', ascending: true);
    return (res as List).map((e) => PendudukModel.fromJson(e)).toList();
  }

  Future<PendudukModel?> getPendudukById(int id) async {
    final res = await SupabaseProvider.pendudukTable
        .select()
        .eq('id_penduduk', id)
        .maybeSingle();
    if (res == null) return null;
    return PendudukModel.fromJson(res);
  }

  Future<List<PendudukModel>> searchPenduduk(String query) async {
    final res = await SupabaseProvider.pendudukTable
        .select()
        .or('nama.ilike.%$query%,nik.ilike.%$query%')
        .order('nama', ascending: true);
    return (res as List).map((e) => PendudukModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> createPenduduk(PendudukModel penduduk) async {
    try {
      await SupabaseProvider.pendudukTable.insert(penduduk.toJson());
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePenduduk(PendudukModel penduduk) async {
    try {
      final updateData = Map<String, dynamic>.from(penduduk.toJson())
        ..remove('id_penduduk');

      await SupabaseProvider.pendudukTable
          .update(updateData)
          .eq('id_penduduk', penduduk.idPenduduk!);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePendudukPassword(
    int idPenduduk,
    String password,
  ) async {
    try {
      await SupabaseProvider.pendudukTable
          .update({'password': password})
          .eq('id_penduduk', idPenduduk);

      final updatedPenduduk = await getPendudukById(idPenduduk);
      if (updatedPenduduk == null) {
        return {
          'success': false,
          'message': 'Gagal memuat data pengguna setelah update.',
        };
      }

      return {'success': true, 'penduduk': updatedPenduduk};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deletePenduduk(int id) async {
    try {
      await SupabaseProvider.pendudukTable.delete().eq('id_penduduk', id);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<int> getTotalPenduduk() async {
    final res = await SupabaseProvider.pendudukTable.select('id_penduduk');
    return (res as List).length;
  }
}