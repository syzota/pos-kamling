import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import 'admin_notification_controller.dart';

class AdminNotificationView extends GetView<AdminNotificationController> {
  const AdminNotificationView({super.key});

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
          onPressed: () => Get.back(),
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

        if (controller.notifications.isEmpty) {
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Notifikasi admin akan muncul di sini.',
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

        final list = controller.filteredNotifications;

        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
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
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (list.isEmpty)
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
                ...list.map(_notificationCard),
            ],
          ),
        );
      }),
    );
  }

  // ================= HERO =================
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
                    'Semua aktivitas sistem admin akan muncul di sini.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
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

  // ================= FILTER =================
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

  // ================= CARD =================
  Widget _notificationCard(Map<String, dynamic> notif) {
    final isRead = notif['is_read'] == true;
    final type = notif['tipe'] ?? ''; // biar aman null
    final accent = _accentColor(type);

    return GestureDetector(
      onTap: () => controller.markAsRead(notif),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isRead
              ? AppColors.surfaceContainerLowest
              : accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: isRead ? AppColors.outlineVariant : accent.withOpacity(0.22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(_icon(notif['tipe']), color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    notif['judul'] ?? 'Notifikasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (!isRead)
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

            const SizedBox(height: 10),

            Text(
              notif['isi'] ?? '-',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.schedule, size: 14),
                const SizedBox(width: 6),
                Text(
                  controller.formatTimestamp(notif['created_at']),
                  style: GoogleFonts.inter(fontSize: 11),
                ),
                const Spacer(),
                Text(
                  isRead ? 'Sudah dibaca' : 'Ketuk untuk tandai',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isRead ? AppColors.outline : AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= STYLE =================
  Color _accentColor(String? type) {
    final t = type?.toLowerCase() ?? '';
    if (t.contains('pengumuman')) return AppColors.primary;
    if (t.contains('surat')) return AppColors.tertiary;
    return AppColors.secondary;
  }

  IconData _icon(String? type) {
    final t = type?.toLowerCase() ?? '';
    if (t.contains('pengumuman')) return Icons.campaign;
    if (t.contains('surat')) return Icons.description;
    return Icons.notifications;
  }
}
