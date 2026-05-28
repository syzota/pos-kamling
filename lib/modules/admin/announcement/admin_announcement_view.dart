import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'admin_announcement_controller.dart';
import '../../../app/routes/app_routes.dart';

class AdminAnnouncementView extends GetView<AdminAnnouncementController> {
  const AdminAnnouncementView({super.key});

  static const Map<String, Map<String, dynamic>> _categoryConfig = {
    'Semua': {
      'icon': Icons.grid_view_rounded,
      'chipBorder': Color(0xFFD81B60),
      'chipBg': Color(0xFFFFE1E9),
      'chipText': Color(0xFFD81B60),
      'iconBg': Color(0xFFFFE1E9),
      'iconColor': Color(0xFFD81B60),
      'badgeBg': Color(0xFFFFE1E9),
      'badgeText': Color(0xFFD81B60),
    },
    'Umum': {
      'icon': Icons.campaign_rounded,
      'chipBorder': Color(0xFFD1D5DB),
      'chipBg': Color(0xFFF3F4F6),
      'chipText': Color(0xFF6B7280),
      'iconBg': Color(0xFFF3F4F6),
      'iconColor': Color(0xFF6B7280),
      'badgeBg': Color(0xFFF3F4F6),
      'badgeText': Color(0xFF6B7280),
    },
    'Kesehatan': {
      'icon': Icons.favorite_rounded,
      'chipBorder': Color(0xFF0D9488),
      'chipBg': Color(0xFFE6F9F5),
      'chipText': Color(0xFF0D9488),
      'iconBg': Color(0xFFE6F9F5),
      'iconColor': Color(0xFF0D9488),
      'badgeBg': Color(0xFFE6F9F5),
      'badgeText': Color(0xFF0D9488),
    },
    'Keamanan': {
      'icon': Icons.location_on_rounded,
      'chipBorder': Color(0xFFF43F5E),
      'chipBg': Color(0xFFFFF1F2),
      'chipText': Color(0xFFF43F5E),
      'iconBg': Color(0xFFFFF1F2),
      'iconColor': Color(0xFFF43F5E),
      'badgeBg': Color(0xFFFFF1F2),
      'badgeText': Color(0xFFF43F5E),
    },
    'Kegiatan': {
      'icon': Icons.calendar_today_rounded,
      'chipBorder': Color(0xFF4F6FE8),
      'chipBg': Color(0xFFF0F4FF),
      'chipText': Color(0xFF4F6FE8),
      'iconBg': Color(0xFFF0F4FF),
      'iconColor': Color(0xFF4F6FE8),
      'badgeBg': Color(0xFFF0F4FF),
      'badgeText': Color(0xFF4F6FE8),
    },
    'Keuangan': {
      'icon': Icons.monetization_on_rounded,
      'chipBorder': Color(0xFF16A34A),
      'chipBg': Color(0xFFF0FDF4),
      'chipText': Color(0xFF16A34A),
      'iconBg': Color(0xFFF0FDF4),
      'iconColor': Color(0xFF16A34A),
      'badgeBg': Color(0xFFF0FDF4),
      'badgeText': Color(0xFF16A34A),
    },
    'Darurat': {
      'icon': Icons.warning_rounded,
      'chipBorder': Color(0xFFF97316),
      'chipBg': Color(0xFFFFF7ED),
      'chipText': Color(0xFFF97316),
      'iconBg': Color(0xFFFFF7ED),
      'iconColor': Color(0xFFF97316),
      'badgeBg': Color(0xFFFFF7ED),
      'badgeText': Color(0xFFF97316),
    },
  };

  Map<String, dynamic> getConfig(String kategori) {
    return _categoryConfig[kategori] ?? _categoryConfig['Umum']!;
  }

  Color getColor(String kategori) {
    final config = getConfig(kategori);
    return config['iconColor'] as Color;
  }

  IconData getIcon(String kategori) {
    final config = getConfig(kategori);
    return config['icon'] as IconData;
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Tanpa tanggal";

    final now = DateTime.now();
    final localDate = date.toLocal();
    final diff = now.difference(localDate);

    if (diff.isNegative) {
      return "Baru saja ditambahkan";
    }

    if (diff.inSeconds < 5) {
      return "Baru saja ditambahkan";
    }

    if (diff.inSeconds < 60) {
      return "${diff.inSeconds} detik yang lalu";
    }

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} menit yang lalu";
    }

    if (diff.inHours < 24) {
      return "${diff.inHours} jam yang lalu";
    }

    if (diff.inDays < 7) {
      return "${diff.inDays} hari yang lalu";
    }

    if (diff.inDays < 30) {
      final minggu = diff.inDays ~/ 7;
      return "$minggu minggu yang lalu";
    }

    if (diff.inDays < 365) {
      final bulan = diff.inDays ~/ 30;
      return "$bulan bulan yang lalu";
    }

    final tahun = diff.inDays ~/ 365;
    return "$tahun tahun yang lalu";
  }

  void _showDetail(AnnouncementModel e) {
    final kategori = e.kategori;
    final config = getConfig(kategori);
    final color = config['iconColor'] as Color;
    final icon = config['icon'] as IconData;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: config['badgeBg'] as Color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            kategori,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: config['badgeText'] as Color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDate(e.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  e.judul,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),

                const Divider(height: 32),

                Text(
                  e.isi,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F3F5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          ),
        ),
        child: FloatingActionButton.extended(
          onPressed: controller.openCreate,
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Buat Pengumuman",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),

      appBar: AppBar(
        title: Text(
          "Pengumuman",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.offAllNamed(AppRoutes.adminDashboard),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 5,
        isAdmin: true,
        onTap: AppRoutes.navigateAdminBottomNav,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              "Semua Pengumuman",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),

          _buildFilterChips(),

          const SizedBox(height: 12),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.filteredAnnouncements;

              if (list.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.loadAnnouncements,
                color: const Color(0xFFD81B60),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final e = list[i];
                    return _card(e);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _categoryConfig.entries.map((entry) {
          final catName = entry.key;
          final config = entry.value;

          return Obx(() {
            final isSelected = controller.selectedFilter.value == catName;

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => controller.selectedFilter.value = catName,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? config['chipBorder'] as Color
                        : config['chipBg'] as Color,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : config['chipBorder'] as Color,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        config['icon'] as IconData,
                        size: 14,
                        color: isSelected
                            ? Colors.white
                            : config['chipText'] as Color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        catName,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : config['chipText'] as Color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _card(AnnouncementModel e) {
    final kategori = e.kategori;
    final config = getConfig(kategori);
    final color = config['iconColor'] as Color;
    final icon = config['icon'] as IconData;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _showDetail(e),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: config['iconBg'] as Color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),

                    const SizedBox(width: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: config['badgeBg'] as Color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        kategori,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: config['badgeText'] as Color,
                        ),
                      ),
                    ),

                    const Spacer(),

                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey,
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (val) {
                        if (val == 'edit') controller.openEdit(e);
                        if (val == 'delete') controller.hapusPengumuman(e.id);
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Hapus',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  e.judul,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  e.isi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatDate(e.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showDetail(e),
                      child: Row(
                        children: [
                          Text(
                            "Selengkapnya",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Belum ada pengumuman',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
