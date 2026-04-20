import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
                  Expanded(child: _buildEventList()),
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

  Widget _buildEventList() => Obx(() {
    if (controller.selectedDayKegiatan.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 48,
              color: AppColors.outlineVariant,
            ),
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
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
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
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: i == 0
                ? Border(left: BorderSide(color: AppColors.primary, width: 4))
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
              Container(
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
                        color: i == 0 ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                    Text(
                      k.tanggal != null
                          ? DateFormat('MMM').format(k.tanggal!)
                          : '',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: i == 0 ? AppColors.primary : AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
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
                          const Icon(
                            Icons.schedule_rounded,
                            size: 12,
                            color: AppColors.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            k.waktu!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    if (k.lokasi != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 12,
                            color: AppColors.outline,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              k.lokasi!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.secondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  });
}
