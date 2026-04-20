import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/penduduk_repository.dart';

class AdminProfileController extends GetxController {
  final PendudukRepository pendudukRepo;
  AdminProfileController({required this.pendudukRepo});

  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  var isSubmitting = false.obs;

  final pendudukRx = Rxn<PendudukModel>();

  PendudukModel? get penduduk => pendudukRx.value;

  PenggunaModel? get pengguna {
    try {
      return Get.find<PenggunaModel>();
    } catch (_) {
      return null;
    }
  }

  String get namaAdmin => penduduk?.nama ?? pengguna?.username ?? 'Admin';

  @override
  void onInit() {
    super.onInit();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    try {
      if (Get.isRegistered<PendudukModel>()) {
        pendudukRx.value = Get.find<PendudukModel>();
      }
    } catch (e) {
      print(e);
    }
  }
}
