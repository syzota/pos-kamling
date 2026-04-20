import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../data/models/models.dart';
import 'warga_notification_controller.dart';

class WargaNotificationView extends GetView<WargaNotificationController> {
  const WargaNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.secondary,
          ),
          onPressed: () => Get.offNamed(AppRoutes.wargaDashboard),
        ),
        title: Text(
          'Notifikasi',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.hasUnread ? controller.markAllAsRead : null,
              child: Text(
                'Tandai semua',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: controller.hasUnread
                      ? AppColors.primary
                      : AppColors.outline,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.notifikasi.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_off_rounded,
                    size: 64,
                    color: AppColors.outlineVariant,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Belum ada notifikasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Notifikasi akan muncul ketika ada pengumuman, pengajuan surat, atau perubahan status surat.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final filteredNotifications = controller.filteredNotifications;
        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              // 🔥 FIX: hero reactive
              _buildHeroCard(),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('semua'),
                    const SizedBox(width: 8),
                    _filterChip('pengumuman'),
                    const SizedBox(width: 8),
                    _filterChip('surat'),
                    const SizedBox(width: 8),
                    _filterChip('sistem'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (filteredNotifications.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Text(
                    'Belum ada notifikasi pada kategori ini.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...filteredNotifications.map(_notificationCard),
            ],
          ),
        );
      }),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        isAdmin: false,
        onTap: AppRoutes.navigateWargaBottomNav,
      ),
    );
  }

  Widget _buildHeroCard() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${controller.unreadCount} notifikasi belum dibaca',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Update pengumuman dan status surat akan muncul di sini. Tarik ke bawah untuk menyegarkan.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.88),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _filterChip(String value) {
    return Obx(() {
      final isActive = controller.selectedFilter.value == value;
      final label = value == 'semua'
          ? 'Semua'
          : controller.categoryLabel(value);
      return GestureDetector(
        onTap: () => controller.setFilter(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : AppColors.secondary,
            ),
          ),
        ),
      );
    });
  }

  Widget _notificationCard(NotifikasiModel item) {
    final accent = _accentColor(item.tipe);
    final icon = _notificationIcon(item.tipe);
    return GestureDetector(
      onTap: () => controller.markAsRead(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: item.isRead
              ? AppColors.surfaceContainerLowest
              : accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: item.isRead
                ? AppColors.outlineVariant
                : accent.withOpacity(0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withOpacity(0.04),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(icon, color: accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.judul ?? 'Notifikasi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        controller.categoryLabel(
                          controller.notificationCategory(item),
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!item.isRead)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.isi ?? '-',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.secondary,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: AppColors.outline,
                ),
                const SizedBox(width: 6),
                Text(
                  controller.formatTimestamp(item.createdAt),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.outline,
                  ),
                ),
                const Spacer(),
                Text(
                  item.isRead ? 'Sudah dibaca' : 'Ketuk untuk tandai dibaca',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: item.isRead ? AppColors.outline : AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _accentColor(String? tipe) {
    final value = tipe?.toLowerCase() ?? '';
    if (value.contains('ditolak')) {
      return AppColors.error;
    }
    if (value.contains('disetujui')) {
      return AppColors.tertiary;
    }
    if (value.contains('pengumuman')) {
      return AppColors.primary;
    }
    return AppColors.secondary;
  }

  IconData _notificationIcon(String? tipe) {
    final value = tipe?.toLowerCase() ?? '';
    if (value.contains('pengumuman')) {
      return Icons.campaign_rounded;
    }
    if (value.contains('disetujui')) {
      return Icons.verified_rounded;
    }
    if (value.contains('ditolak')) {
      return Icons.cancel_rounded;
    }
    if (value.contains('diproses')) {
      return Icons.hourglass_top_rounded;
    }
    if (value.contains('surat')) {
      return Icons.description_rounded;
    }
    return Icons.notifications_rounded;
  }
}
