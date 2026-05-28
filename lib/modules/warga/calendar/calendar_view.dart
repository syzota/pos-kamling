import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../data/models/models.dart';
import 'calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.offAllNamed(AppRoutes.wargaDashboard),
        ),
        title: Text(
          'Kalender Kegiatan',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Column(
                children: [
                  _buildCalendar(),
                  const Divider(height: 1, color: AppColors.outlineVariant),
                  Expanded(child: _buildEventList(context)),
                ],
              ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        isAdmin: false,
        onTap: AppRoutes.navigateWargaBottomNav,
      ),
    );
  }

  Widget _buildCalendar() => Obx(
    () => Container(
      color: AppColors.surfaceContainerLowest,
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: controller.focusedDay.value,
        selectedDayPredicate: (day) =>
            isSameDay(controller.selectedDay.value, day),
        eventLoader: (day) => controller.getEventsForDay(day),
        onDaySelected: controller.onDaySelected,
        onPageChanged: controller.onPageChanged,
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryFixed,
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markerSize: 6,
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: AppColors.onSurface,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.secondary,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.secondary,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
          weekendStyle: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.error,
          ),
        ),
      ),
    ),
  );

  Widget _buildEventList(BuildContext context) => Obx(() {
    if (controller.selectedDayKegiatan.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded,
                size: 48, color: AppColors.outlineVariant),
            const SizedBox(height: 12),
            Text(
              'Tidak ada kegiatan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
            Text(
              'pada tanggal ini',
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.outline),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: controller.selectedDayKegiatan.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final k = controller.selectedDayKegiatan[i];
        return GestureDetector(
          onTap: () => _showDetailSheet(context, k),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusL),
              border: i == 0
                  ? Border(
                      left: BorderSide(
                          color: AppColors.primary, width: 4))
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withOpacity(0.05),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              children: [
                if (k.foto != null && k.foto!.isNotEmpty)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                    child: Image.network(
                      k.foto!,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _fallbackDateBox(k, i),
                    ),
                  )
                else
                  _fallbackDateBox(k, i),

                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        k.namaKegiatan ?? 'Kegiatan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (k.waktu != null)
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded,
                                size: 12, color: AppColors.outline),
                            const SizedBox(width: 4),
                            Text(
                              k.waktu!,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.secondary),
                            ),
                          ],
                        ),
                      if (k.lokasi != null)
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                size: 12, color: AppColors.outline),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                k.lokasi!,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.secondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (k.latitude != null && k.longitude != null)
                  const Icon(Icons.map_rounded,
                      size: 18, color: AppColors.primary),
              ],
            ),
          ),
        );
      },
    );
  });

  Widget _fallbackDateBox(KegiatanModel k, int i) => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: i == 0
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              k.tanggal != null
                  ? DateFormat('dd').format(k.tanggal!)
                  : '--',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color:
                    i == 0 ? AppColors.primary : AppColors.secondary,
              ),
            ),
            Text(
              k.tanggal != null
                  ? DateFormat('MMM').format(k.tanggal!)
                  : '',
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: i == 0
                    ? AppColors.primary
                    : AppColors.outline,
              ),
            ),
          ],
        ),
      );

  void _showDetailSheet(BuildContext context, KegiatanModel k) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _KegiatanDetailSheet(k: k),
    );
  }
}

class _KegiatanDetailSheet extends StatelessWidget {
  final KegiatanModel k;
  const _KegiatanDetailSheet({required this.k});

  @override
  Widget build(BuildContext context) {
    final hasMap  = k.latitude != null && k.longitude != null;
    final hasFoto = k.foto != null && k.foto!.isNotEmpty;

    return DraggableScrollableSheet(
      initialChildSize: hasFoto || hasMap ? 0.9 : 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(99),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasFoto)
                      _buildFotoSection(context),

                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  k.namaKegiatan ?? '-',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ),
                              if (k.jenisKegiatan != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    k.jenisKegiatan!,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _infoRow(
                            Icons.calendar_today_rounded,
                            'Tanggal',
                            k.tanggal != null
                                ? DateFormat('EEEE, dd MMMM yyyy',
                                        'id')
                                    .format(k.tanggal!)
                                : '-',
                          ),
                          const SizedBox(height: 10),
                          _infoRow(
                            Icons.access_time_rounded,
                            'Waktu',
                            k.waktu != null
                                ? k.waktu!.substring(0, 5)
                                : '-',
                          ),
                          const SizedBox(height: 10),
                          _infoRow(Icons.place_rounded, 'Lokasi',
                              k.lokasi ?? '-'),

                          if (k.deskripsi != null &&
                              k.deskripsi!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _infoRow(Icons.notes_rounded,
                                'Deskripsi', k.deskripsi!),
                          ],

                          if (hasMap) ...[
                            const SizedBox(height: 20),
                            Text(
                              'LOKASI DI PETA',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                height: 250,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        k.latitude!, k.longitude!),
                                    zoom: 16,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId:
                                          const MarkerId('lokasi'),
                                      position: LatLng(
                                          k.latitude!, k.longitude!),
                                      infoWindow: InfoWindow(
                                        title: k.namaKegiatan ??
                                            'Lokasi Kegiatan',
                                        snippet: k.lokasi,
                                      ),
                                    ),
                                  },
                                  zoomControlsEnabled: true,
                                  myLocationButtonEnabled: false,
                                  mapToolbarEnabled: true,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFotoSection(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullImage(context),
      child: Stack(
        children: [
          Hero(
            tag: 'foto_kegiatan_${k.idKegiatan}',
            child: Image.network(
              k.foto!,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: AppColors.surfaceContainerHigh,
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 100,
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.broken_image_rounded,
                    color: AppColors.outline, size: 40),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fullscreen_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              k.namaKegiatan ?? 'Foto Kegiatan',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Hero(
                tag: 'foto_kegiatan_${k.idKegiatan}',
                child: Image.network(
                  k.foto!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.secondary)),
                const SizedBox(height: 2),
                Text(value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    )),
              ],
            ),
          ),
        ],
      );
}