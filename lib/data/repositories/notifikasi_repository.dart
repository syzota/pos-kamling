import '../providers/supabase_provider.dart';
import '../models/models.dart';

class NotifikasiRepository {
  Future<List<NotifikasiModel>> getNotifikasiByPenduduk(int idPenduduk) async {
    final res = await SupabaseProvider.notifikasiTable
        .select()
        .eq('id_penduduk', idPenduduk)
        .order('created_at', ascending: false);
    return (res as List).map((e) => NotifikasiModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> createNotification({
    required int idPenduduk,
    required String judul,
    required String isi,
    String? tipe,
  }) async {
    try {
      await SupabaseProvider.notifikasiTable.insert({
        'id_penduduk': idPenduduk,
        'judul': judul,
        'isi': isi,
        if (tipe != null) 'tipe': tipe,
        'created_at': DateTime.now().toIso8601String(),
        'is_read': false,
      });
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createNotificationForAllUsers({
    required String judul,
    required String isi,
    String? tipe,
  }) async {
    try {
      final pendudukData = await SupabaseProvider.pendudukTable.select('id_penduduk');
      final inserts = (pendudukData as List)
          .map((e) => {
                'id_penduduk': e['id_penduduk'],
                'judul': judul,
                'isi': isi,
                if (tipe != null) 'tipe': tipe,
                'created_at': DateTime.now().toIso8601String(),
                'is_read': false,
              })
          .toList();
      if (inserts.isNotEmpty) {
        await SupabaseProvider.notifikasiTable.insert(inserts);
      }
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> markAsRead(int idNotifikasi) async {
    try {
      await SupabaseProvider.notifikasiTable
          .update({'is_read': true})
          .eq('id_notifikasi', idNotifikasi);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> markAllAsRead(int idPenduduk) async {
    try {
      await SupabaseProvider.notifikasiTable
          .update({'is_read': true})
          .eq('id_penduduk', idPenduduk)
          .eq('is_read', false);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
