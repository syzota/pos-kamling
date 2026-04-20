import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/kegiatan_repository.dart';

class CalendarController extends GetxController {
  final KegiatanRepository kegiatanRepo;
  CalendarController({required this.kegiatanRepo});

  var allKegiatan = <KegiatanModel>[].obs;
  var selectedDayKegiatan = <KegiatanModel>[].obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  var isLoading = false.obs;

  Map<DateTime, List<KegiatanModel>> get eventMap {
    final map = <DateTime, List<KegiatanModel>>{};
    for (final k in allKegiatan) {
      if (k.tanggal != null) {
        final d = DateTime(k.tanggal!.year, k.tanggal!.month, k.tanggal!.day);
        map[d] = [...(map[d] ?? []), k];
      }
    }
    return map;
  }

  List<KegiatanModel> getEventsForDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return eventMap[d] ?? [];
  }

  @override
  void onInit() {
    super.onInit();
    loadKegiatan();
  }

  Future<void> loadKegiatan() async {
    isLoading.value = true;
    try {
      allKegiatan.value = await kegiatanRepo.getAllKegiatan();
      selectedDayKegiatan.value = getEventsForDay(selectedDay.value);
    } catch (_) {}
    isLoading.value = false;
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
    selectedDayKegiatan.value = getEventsForDay(selected);
  }

  void onPageChanged(DateTime focused) => focusedDay.value = focused;
}