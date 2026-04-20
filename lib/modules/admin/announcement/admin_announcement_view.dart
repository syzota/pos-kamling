import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'admin_announcement_controller.dart';
import '../../../app/routes/app_routes.dart';

class AdminAnnouncementView extends GetView<AdminAnnouncementController> {
  const AdminAnnouncementView({super.key});

  Color getColor(String kategori) {
    switch (kategori) {
      case 'Kesehatan':
        return const Color(0xFF26A69A);
      case 'Keamanan':
        return const Color(0xFFEF5350);
      case 'Kegiatan':
        return const Color(0xFF5C6BC0);
      case 'Keuangan':
        return const Color(0xFF66BB6A);
      case 'Darurat':
        return const Color(0xFFFF7043);
      default:
        return const Color(0xFF78909C);
    }
  }

  IconData getIcon(String kategori) {
    switch (kategori) {
      case 'Kesehatan':
        return Icons.health_and_safety_rounded;
      case 'Keamanan':
        return Icons.security_rounded;
      case 'Kegiatan':
        return Icons.event_rounded;
      case 'Keuangan':
        return Icons.account_balance_wallet_rounded;
      case 'Darurat':
        return Icons.warning_amber_rounded;
      default:
        return Icons.campaign_rounded;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Tanpa tanggal";

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return "Baru saja";
    if (diff.inMinutes < 60) return "${diff.inMinutes} menit lalu";
    if (diff.inHours < 24) return "${diff.inHours} jam lalu";
    if (diff.inDays == 1) return "Kemarin";
    if (diff.inDays < 7) return "${diff.inDays} hari lalu";

    return "${date.day}/${date.month}/${date.year}";
  }

  void _showDetail(dynamic e) {
    final color = getColor(e.kategori ?? '');
    final icon = getIcon(e.kategori ?? '');

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
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
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            e.kategori ?? 'Umum',
                            style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDate(e.tanggal),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  e.judul ?? '',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.2),
                ),

                const SizedBox(height: 12),
                Text(
                  e.isi ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: Get.back,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Tutup",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
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
        children: [
          // ───── FILTER CHIPS ─────
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Row(
                children: controller.kategoriList.map((k) {
                  final isActive = controller.selectedFilter.value == k;
                  final color = getColor(k);

                  return GestureDetector(
                    onTap: () => controller.selectedFilter.value = k,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? color : color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            getIcon(k),
                            size: 14,
                            color: isActive ? Colors.white : color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            k,
                            style: TextStyle(
                              color: isActive ? Colors.white : color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),

          // ───── LIST ─────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.filteredAnnouncements;

              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada pengumuman",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final e = list[i];
                  return _card(e);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _card(AnnouncementModel e) {
    final color = getColor(e.kategori);
    final icon = getIcon(e.kategori);

    return GestureDetector(
      onTap: () => _showDetail(e),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── ICON ─────
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),

            const SizedBox(width: 12),

            // ───── CONTENT ─────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      e.kategori,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Judul
                  Text(
                    e.judul,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Isi preview
                  Text(
                    e.isi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 10),

                  // Bottom row: tanggal + selengkapnya
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
                            formatDate(e.tanggal),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      GestureDetector(
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

            // ───── POPUP MENU (Edit & Hapus) ─────
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  controller.openEdit(e);
                } else if (value == 'delete') {
                  controller.hapusPengumuman(e.id);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Edit",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Hapus",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
