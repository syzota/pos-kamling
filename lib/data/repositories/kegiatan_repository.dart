import '../providers/supabase_provider.dart';
import '../models/models.dart';

class KegiatanRepository {
  Future<List<KegiatanModel>> getAllKegiatan() async {
    final res = await SupabaseProvider.kegiatanTable
        .select()
        .order('tanggal', ascending: true);
    return (res as List).map((e) => KegiatanModel.fromJson(e)).toList();
  }

  Future<List<KegiatanModel>> getUpcomingKegiatan() async {
    final now = DateTime.now().toIso8601String().split('T').first;
    final res = await SupabaseProvider.kegiatanTable
        .select()
        .gte('tanggal', now)
        .order('tanggal', ascending: true)
        .limit(10);
    return (res as List).map((e) => KegiatanModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> createKegiatan(KegiatanModel kegiatan) async {
    try {
      await SupabaseProvider.kegiatanTable.insert(kegiatan.toJson());
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateKegiatan(KegiatanModel kegiatan) async {
    try {
      await SupabaseProvider.kegiatanTable
          .update(kegiatan.toJson())
          .eq('id_kegiatan', kegiatan.idKegiatan!);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteKegiatan(int id) async {
    try {
      await SupabaseProvider.kegiatanTable.delete().eq('id_kegiatan', id);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}