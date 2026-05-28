import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/pengumuman_repository.dart';

class AnnouncementController extends GetxController {
  final PengumumanRepository pengumumanRepo;
  AnnouncementController({required this.pengumumanRepo});

  var pengumuman = <PengumumanModel>[].obs;
  var categories = <String>[].obs;
  var selectedKategori = 'Semua'.obs;
  var isLoading = false.obs;
  var selectedPengumuman = Rx<PengumumanModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCategoriesAndAnnouncements();
  }

  Future<void> loadCategoriesAndAnnouncements() async {
    isLoading.value = true;
    try {
      categories.value = await pengumumanRepo.getCategories();
      if (!categories.contains('Semua')) {
        categories.insert(0, 'Semua');
      }
      if (!categories.contains(selectedKategori.value)) {
        selectedKategori.value = 'Semua';
      }
      pengumuman.value = await pengumumanRepo.getAllPengumuman();
    } catch (_) {
      categories.value = ['Semua'];
      selectedKategori.value = 'Semua';
      pengumuman.value = await pengumumanRepo.getAllPengumuman();
    }
    isLoading.value = false;
  }

  List<PengumumanModel> get filteredPengumuman {
    if (selectedKategori.value == 'Semua') {
      return pengumuman;
    }
    return pengumuman
        .where((p) => p.kategori?.toLowerCase() == selectedKategori.value.toLowerCase())
        .toList();
  }

  void selectKategori(String kategori) {
    selectedKategori.value = kategori;
  }

  void openDetail(PengumumanModel p) => selectedPengumuman.value = p;
  void closeDetail() => selectedPengumuman.value = null;
}
