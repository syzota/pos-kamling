import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'announcement_controller.dart';

class AnnouncementView extends GetView<AnnouncementController> {
  const AnnouncementView({super.key});

  // --- Konfigurasi warna per kategori (FIXED - lengkap semua key) ---
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE1E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.campaign_rounded,
                color: Color(0xFFD81B60),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Pengumuman',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFFD81B60),
              size: 28,
            ),
            onPressed: controller.loadCategoriesAndAnnouncements,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD81B60)),
          );
        }

        final announcements = controller.filteredPengumuman;

        return Column(
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
              child: RefreshIndicator(
                onRefresh: controller.loadCategoriesAndAnnouncements,
                color: const Color(0xFFD81B60),
                child: announcements.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: announcements.length,
                        itemBuilder: (context, index) =>
                            _announcementItem(announcements[index]),
                      ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 4,
        isAdmin: false,
        onTap: AppRoutes.navigateWargaBottomNav,
      ),
    );
  }

  String formatDate(dynamic e) {
    if (e.createdAt != null) {
      return DateFormat('dd MMM yyyy').format(e.createdAt);
    }
    if (e.tanggal != null) {
      return DateFormat('dd MMM yyyy').format(e.tanggal);
    }
    return '-';
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
            final isSelected = controller.selectedKategori.value == catName;

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => controller.selectKategori(catName),
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

  Widget _announcementItem(dynamic p) {
    final String kategori = p.kategori ?? 'Umum';
    final config = _categoryConfig[kategori] ?? _categoryConfig['Umum']!;

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
          onTap: () => _showDetail(p),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Ikon kategori
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: config['iconBg'] as Color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        config['icon'] as IconData,
                        color: config['iconColor'] as Color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Badge kategori berwarna
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
                    const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  p.judul ?? 'Tanpa Judul',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  p.isi ?? '',
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
                          p.createdAt != null
                              ? DateFormat('dd MMM yyyy').format(p.createdAt!)
                              : '-',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    // FIXED: pakai AbsorbPointer false + GestureDetector behaviour agar
                    // tidak tertimpa InkWell parent. HitTestBehavior.opaque memastikan tap
                    // ditangkap oleh GestureDetector ini duluan.
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _showDetail(p);
                      },
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

  // FIXED: Hanya satu method _showDetail, menggabungkan kedua versi sebelumnya.
  // Menggunakan _categoryConfig untuk resolve color & icon (menggantikan variabel
  // `color` dan `icon` yang tidak terdefinisi di versi duplikat sebelumnya).
  void _showDetail(dynamic p) {
    final String kategori = p.kategori ?? 'Umum';
    final config = _categoryConfig[kategori] ?? _categoryConfig['Umum']!;
    final Color color = config['iconColor'] as Color;
    final IconData icon = config['icon'] as IconData;

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
                        // FIXED: tampilkan waktu dengan format lengkap jam:menit
                        Text(
                          p.createdAt != null
                              ? DateFormat(
                                  'dd MMM yyyy, HH:mm',
                                ).format(p.createdAt!)
                              : p.createdAt != null
                              ? DateFormat(
                                  'dd MMM yyyy, HH:mm',
                                ).format(p.createdAt!)
                              : '-',
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
                  p.judul ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const Divider(height: 32),
                Text(
                  p.isi ?? '',
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
      // FIXED: backgroundColor transparan agar borderRadius atas terlihat,
      // enableDrag true agar bisa di-swipe tutup, isScrollControlled true
      // agar konten panjang tidak terpotong.
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: true,
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
