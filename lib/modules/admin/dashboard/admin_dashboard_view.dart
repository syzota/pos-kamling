import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import 'admin_dashboard_controller.dart';
import '../announcement/admin_announcement_binding.dart';
import '../announcement/admin_announcement_view.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ✅ FIX 1: Drawer dipindah ke dalam Scaffold agar Builder context bekerja
      drawer: _buildDrawer(),

      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _buildBody(),
      ),

      bottomNavigationBar: _buildBottomNav(0),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(
          () => const AdminAnnouncementView(),
          binding: AdminAnnouncementBinding(),
        ),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Pengumuman',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ✅ FIX 2: Drawer dijadikan method sendiri agar rapi dan bisa akses controller
  Widget _buildDrawer() => Drawer(
    child: SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  'Admin',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'admin@email.com',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.adminProfile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: controller.logout,
          ),
        ],
      ),
    ),
  );

  Widget _buildBody() => CustomScrollView(
    slivers: [
      SliverAppBar(
        floating: true,
        pinned: false,
        backgroundColor: AppColors.surfaceContainerLowest.withValues(
          alpha: 0.95,
        ),
        automaticallyImplyLeading: false,

        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.secondary,
            ),
            onPressed: () => Get.toNamed(AppRoutes.adminNotification),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.secondary),
            onPressed: controller.logout,
          ),
        ],
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            Text(
              'Dashboard Admin',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Here's what's happening today.",
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            _buildStatCards(),
            const SizedBox(height: 24),
            _buildPendingSurat(),
            const SizedBox(height: 24),
            _buildRecentTransaksi(),
          ]),
        ),
      ),
    ],
  );

  Widget _buildStatCards() => Obx(
    () => Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                'Total Warga',
                '${controller.totalWarga.value}',
                Icons.groups_rounded,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                badge: '+Baru',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                'Surat Pending',
                '${controller.pendingSurat.length}',
                Icons.mail_rounded,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                badge: 'Urgent',
                badgeColor: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                // ✅ FIX 5: Ganti withOpacity() → withValues(alpha:) (Flutter 3.27+)
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SALDO KAS BULAN INI',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.formatRpFull(controller.saldo.value),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _statCard(
    String title,
    String value,
    IconData icon, {
    Color? iconBg,
    Color? iconColor,
    String? badge,
    Color? badgeColor,
  }) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      boxShadow: [
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: 0.05),
          blurRadius: 16,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg ?? AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20,
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: (badgeColor ?? AppColors.tertiary).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: badgeColor ?? AppColors.tertiary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
          ),
        ),
      ],
    ),
  );

  Widget _buildPendingSurat() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Surat Pending',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.adminLetters),
            child: Text(
              'Lihat Semua',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Obx(() {
        if (controller.pendingSurat.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Text(
              'Semua surat sudah diproses ',
              style: GoogleFonts.inter(
                color: AppColors.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        return Column(
          children: controller.pendingSurat
              .take(3)
              .map(
                (s) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.onSurface.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                        child: const Icon(
                          Icons.description_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.penduduk?.nama ?? 'Warga',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              s.jenisSurat ?? 'Surat',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.secondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.adminLetters),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Proses',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      }),
    ],
  );

  Widget _buildRecentTransaksi() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transaksi Terbaru',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.adminFinance),
            child: Text(
              'Lihat Semua',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Obx(() {
        if (controller.recentTransaksi.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Text(
              'Belum ada transaksi',
              style: GoogleFonts.inter(color: AppColors.secondary),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.05),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            children: controller.recentTransaksi.asMap().entries.map((e) {
              final t = e.value;
              final isLast = e.key == controller.recentTransaksi.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                (t.isPemasukan
                                        ? AppColors.tertiary
                                        : AppColors.error)
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM,
                            ),
                          ),
                          child: Icon(
                            t.isPemasukan
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            color: t.isPemasukan
                                ? AppColors.tertiary
                                : AppColors.error,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.keterangan ?? 'Transaksi',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                t.tanggal != null
                                    ? DateFormat(
                                        'dd MMM yyyy',
                                      ).format(t.tanggal!)
                                    : '',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${t.isPemasukan ? '+' : '-'} ${controller.formatRpFull(t.nominal ?? 0)}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: t.isPemasukan
                                ? AppColors.tertiary
                                : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      indent: 14,
                      endIndent: 14,
                      color: AppColors.outlineVariant,
                    ),
                ],
              );
            }).toList(),
          ),
        );
      }),
    ],
  );

  Widget _buildBottomNav(int currentIndex) {
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': 'Home'},
      {'icon': Icons.people_rounded, 'label': 'Warga'},
      {'icon': Icons.description_rounded, 'label': 'Surat'},
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'Keuangan'},
      {'icon': Icons.event_note_rounded, 'label': 'Kegiatan'},
      {'icon': Icons.campaign_rounded, 'label': 'Pengumuman'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = i == currentIndex;

            return GestureDetector(
              onTap: () => controller.navigateTo(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      items[i]['icon'] as IconData,
                      size: 22,
                      color: isActive ? AppColors.primary : AppColors.outline,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    items[i]['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? AppColors.primary : AppColors.outline,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showProfileDialog() => Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.primaryFixed,
              child: Icon(Icons.person, size: 35, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              'Admin',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'admin@email.com',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: Get.back,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                ),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // ✅ FIX 7: Method ini tetap ada tapi tidak dipakai — bisa dihapus
  //           atau dihubungkan ke suatu tombol jika memang diperlukan
  // void _showCreateAnnouncementDialog() { ... }
}
