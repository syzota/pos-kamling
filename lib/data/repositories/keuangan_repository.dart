import '../providers/supabase_provider.dart';
import '../models/models.dart';

class KeuanganRepository {
  Future<List<KeuanganModel>> getAllKeuangan() async {
    final res = await SupabaseProvider.keuanganTable
        .select()
        .order('tanggal', ascending: false);
    return (res as List).map((e) => KeuanganModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getSaldoTotal() async {
    final all = await getAllKeuangan();
    double pemasukan = 0;
    double pengeluaran = 0;
    for (final k in all) {
      if (k.isPemasukan) {
        pemasukan += k.nominal ?? 0;
      } else {
        pengeluaran += k.nominal ?? 0;
      }
    }
    return {
      'saldo': pemasukan - pengeluaran,
      'pemasukan': pemasukan,
      'pengeluaran': pengeluaran,
    };
  }

  Future<Map<String, dynamic>> createKeuangan(KeuanganModel keuangan) async {
    try {
      await SupabaseProvider.keuanganTable.insert(keuangan.toJson());
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateKeuangan(KeuanganModel keuangan) async {
    try {
      await SupabaseProvider.keuanganTable
          .update(keuangan.toJson())
          .eq('id_keuangan', keuangan.idKeuangan!);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteKeuangan(int id) async {
    try {
      await SupabaseProvider.keuanganTable.delete().eq('id_keuangan', id);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}