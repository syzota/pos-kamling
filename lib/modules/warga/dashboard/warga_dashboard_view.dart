import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'warga_dashboard_controller.dart';

class WargaDashboardView extends GetView<WargaDashboardController> {
  const WargaDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Drawer(
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
                      controller.namaWarga,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      controller.penduduk?.nik ??
                          controller.pengguna?.username ??
                          '',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () {
                  Get.back();
                  Get.offNamed(AppRoutes.wargaProfile);
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
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _buildBody(),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        isAdmin: false,
        onTap: AppRoutes.navigateWargaBottomNav,
      ),
    );
  }

  Widget _buildBody() => CustomScrollView(
    slivers: [
      SliverAppBar(
        floating: true,
        pinned: false,
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.secondary),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
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
              child: const Icon(Icons.person_rounded, color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.secondary,
            ),
            onPressed: () => Get.offNamed(AppRoutes.wargaNotification),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.secondary),
            onPressed: controller.logout,
          ),
        ],
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            _sectionHeader(
              'Pengumuman Terbaru',
              action: 'Lihat Semua',
              onAction: () => Get.toNamed(AppRoutes.wargaAnnouncement),
            ),
            const SizedBox(height: 12),
            _buildAnnouncements(),
            const SizedBox(height: 24),
            _sectionHeader('Layanan Cepat'),
            const SizedBox(height: 12),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildUpcomingEvent(),
            const SizedBox(height: 24),
            _buildStatusIuran(),
          ]),
        ),
      ),
    ],
  );

  Widget _sectionHeader(
    String title, {
    String? action,
    VoidCallback? onAction,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.onSurface,
        ),
      ),
      if (action != null)
        GestureDetector(
          onTap: onAction,
          child: Text(
            action,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
    ],
  );

  Widget _buildAnnouncements() => Obx(() {
    if (controller.pengumuman.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Center(
          child: Text(
            'Belum ada pengumuman',
            style: GoogleFonts.inter(color: AppColors.secondary),
          ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.pengumuman.length.clamp(0, 5),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final p = controller.pengumuman[i];

          // 🔥 LOGIC WARNA + ICON SESUAI KATEGORI
          final kategori = (p.kategori ?? 'Umum').toLowerCase();

          Color badgeColor;
          Color bgColor;
          IconData icon;

          switch (kategori) {
            case 'darurat':
              badgeColor = const Color(0xFFF97316);
              bgColor = badgeColor.withOpacity(0.12);
              icon = Icons.warning_amber_rounded;
              break;

            case 'kesehatan':
              badgeColor = const Color(0xFF10B981);
              bgColor = badgeColor.withOpacity(0.12);
              icon = Icons.favorite_rounded;
              break;

            case 'keamanan':
              badgeColor = const Color(0xFFEF4444);
              bgColor = badgeColor.withOpacity(0.12);
              icon = Icons.shield_rounded;
              break;

            case 'kegiatan':
              badgeColor = const Color(0xFF3B82F6);
              bgColor = badgeColor.withOpacity(0.12);
              icon = Icons.event_rounded;
              break;

            case 'keuangan':
              badgeColor = const Color(0xFF22C55E);
              bgColor = badgeColor.withOpacity(0.12);
              icon = Icons.attach_money_rounded;
              break;

            default:
              badgeColor = Colors.grey;
              bgColor = Colors.grey.withOpacity(0.12);
              icon = Icons.campaign_rounded;
          }

          return Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withOpacity(0.05),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 HEADER (ICON + BADGE)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 14, color: badgeColor),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        p.kategori ?? 'Umum',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 📝 JUDUL
                Text(
                  p.judul ?? 'Tanpa Judul',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // 📄 ISI
                Expanded(
                  child: Text(
                    p.isi ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.secondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 📅 TANGGAL
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: AppColors.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      p.createdAt != null
                          ? DateFormat('dd MMM yyyy').format(p.createdAt!)
                          : '',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  });

  Widget _buildQuickActions() {
    final items = [
      {
        'icon': Icons.description_rounded,
        'label': 'Ajukan\nSurat',
        'route': AppRoutes.wargaLetter,
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'label': 'Kas RT',
        'route': AppRoutes.wargaFinance,
      },
      {
        'icon': Icons.calendar_month_rounded,
        'label': 'Kalender',
        'route': AppRoutes.wargaCalendar,
      },
      {
        'icon': Icons.campaign_rounded,
        'label': 'Pengumuman',
        'route': AppRoutes.wargaAnnouncement,
      },
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items
          .map(
            (a) => GestureDetector(
              onTap: () => Get.offNamed(a['route'] as String),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.onSurface.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      a['icon'] as IconData,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 64,
                    child: Text(
                      a['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildUpcomingEvent() => Obx(() {
    if (controller.upcomingKegiatan.isEmpty) return const SizedBox.shrink();
    final k = controller.upcomingKegiatan.first;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Agenda Terdekat',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      k.namaKegiatan ?? 'Kegiatan RT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (k.tanggal != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('dd').format(k.tanggal!),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(k.tanggal!).toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (k.waktu != null)
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Text(
                  k.waktu!,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          const SizedBox(height: 4),
          if (k.lokasi != null)
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 14,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Text(
                  k.lokasi!,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.wargaCalendar),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                'Lihat Kalender Kegiatan',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });

  Widget _buildStatusIuran() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Iuran',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              'Periode ${DateFormat('MMMM yyyy').format(DateTime.now())}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lunas',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color.fromARGB(255, 0, 255, 55),
              size: 28,
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.wargaFinance),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withOpacity(0.06),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  'Detail',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
