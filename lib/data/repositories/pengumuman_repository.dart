import '../providers/supabase_provider.dart';
import '../models/models.dart';

class PengumumanRepository {
  Future<List<PengumumanModel>> getAllPengumuman() async {
    final res = await SupabaseProvider.pengumumanTable.select().order(
      'tanggal',
      ascending: false,
    );
    return (res as List).map((e) => PengumumanModel.fromJson(e)).toList();
  }

  Future<List<String>> getCategories() async {
    final res = await SupabaseProvider.pengumumanTable
        .select('kategori')
        .order('kategori', ascending: true);
    final categories = (res as List)
        .map((e) => (e as Map<String, dynamic>)['kategori']?.toString() ?? '')
        .where((kategori) => kategori.isNotEmpty)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  Future<Map<String, dynamic>> createPengumuman(
    PengumumanModel pengumuman,
  ) async {
    try {
      // 1. simpan pengumuman
      await SupabaseProvider.pengumumanTable.insert(pengumuman.toJson());

      // 2. ambil hanya warga (🔥 OPSI 1)
      final users = await SupabaseProvider.client
          .from('penduduk')
          .select('id_penduduk')
          .eq('role', 'warga');

      // 3. kirim notifikasi ke semua warga
      for (final user in users) {
        await SupabaseProvider.client.from('notifikasi').insert({
          'id_penduduk': user['id_penduduk'],
          'judul': pengumuman.judul,
          'isi': pengumuman.deskripsi ?? '',
          'tipe': 'pengumuman',
          'is_read': false,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePengumuman(
    PengumumanModel pengumuman,
  ) async {
    try {
      await SupabaseProvider.pengumumanTable
          .update(pengumuman.toJson())
          .eq('id_pengumuman', pengumuman.idPengumuman!);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deletePengumuman(int id) async {
    try {
      await SupabaseProvider.pengumumanTable.delete().eq('id_pengumuman', id);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
