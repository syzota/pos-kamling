import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'activities_controller.dart';
import '../../../app/routes/app_routes.dart';

import '../../../data/models/models.dart';

class ActivitiesView extends GetView<ActivitiesController> {
  const ActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Kegiatan RT',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_rounded,
              color: AppColors.primary,
            ),
            onPressed: controller.openAdd,
            tooltip: 'Tambah Kegiatan',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (controller.activities.isEmpty) {
          return _buildEmpty();
        }
        return RefreshIndicator(
          onRefresh: controller.loadActivities,
          color: AppColors.primary,
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.activities.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: MediaQuery.of(context).size.width < 600
                  ? 0.75
                  : 0.7,
            ),
            itemBuilder: (_, i) => _buildActivityCard(controller.activities[i]),
          ),
        );
      }),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 4,
        isAdmin: true,
        onTap: AppRoutes.navigateAdminBottomNav,
      ),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.event_note_outlined,
          size: 64,
          color: AppColors.outlineVariant,
        ),
        const SizedBox(height: 12),
        Text(
          'Belum ada kegiatan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap tombol + untuk menambah kegiatan',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: controller.openAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Kegiatan'),
        ),
      ],
    ),
  );

  Widget _buildActivityCard(KegiatanModel k) {
    final accent = controller.colorForJenis(k.jenisKegiatan);
    return GestureDetector(
      onTap: () => controller.openDetail(k),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BAGIAN GAMBAR
          Stack(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (k.foto != null && k.foto!.isNotEmpty)
                      ? Image.network(
                          k.foto!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(Icons.broken_image, color: accent),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.event_rounded,
                            color: accent,
                            size: 36,
                          ),
                        ),
                ),
              ),
              // MENU POPUP (EDIT/DELETE)
              Positioned(
                top: 0, // Disesuaikan agar lebih rapat ke pojok
                right: 0,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white, // Putih agar terlihat di atas gambar
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (val) {
                    if (val == 'edit') controller.openEdit(k);
                    if (val == 'delete') controller.deleteActivity(k);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // BAGIAN KONTEN TEKS (Menggunakan Expanded jika di dalam Row/Flexible)
          // Jika Column ini adalah anak dari Card dengan tinggi tetap,
          // gunakan Expanded pada kolom teks ini.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  k.namaKegiatan ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),

                if (k.jenisKegiatan != null)
                  Text(
                    k.jenisKegiatan!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.secondary,
                    ),
                  ),
                if (k.deskripsi != null && k.deskripsi!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      k.deskripsi!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.outline,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 8,
                ), // Mendorong info tanggal & lokasi ke bawah agar sejajar
                if (k.tanggal != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: AppColors.outline,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            DateFormat('dd MMM yyyy').format(k.tanggal!),
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.outline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (k.lokasi != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        size: 12,
                        color: AppColors.outline,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          k.lokasi!,
                          maxLines: 1,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.outline,
                          ),
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
  }
}

// ===================== DETAIL VIEW =====================
class ActivityDetailView extends GetView<ActivitiesController> {
  const ActivityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final k = controller.selectedActivity.value!;
    final accent = controller.colorForJenis(k.jenisKegiatan);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Kegiatan',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
            onPressed: () => controller.openEdit(k),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (k.jenisKegiatan != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        k.jenisKegiatan!,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    k.namaKegiatan ?? '-',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withOpacity(0.05),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _infoRow(
                    Icons.calendar_today_rounded,
                    'Tanggal',
                    k.tanggal != null
                        ? DateFormat('EEEE, dd MMMM yyyy').format(k.tanggal!)
                        : '-',
                    accent,
                  ),
                  const Divider(height: 20, color: AppColors.outlineVariant),
                  _infoRow(
                    Icons.access_time_rounded,
                    'Waktu',
                    k.waktu != null ? k.waktu!.substring(0, 5) : '-',
                    accent,
                  ),
                  const Divider(height: 20, color: AppColors.outlineVariant),
                  _infoRow(
                    Icons.place_rounded,
                    'Lokasi',
                    k.lokasi ?? '-',
                    accent,
                  ),
                  if (k.deskripsi != null && k.deskripsi!.isNotEmpty) ...[
                    const Divider(height: 20, color: AppColors.outlineVariant),
                    _infoRow(
                      Icons.notes_rounded,
                      'Deskripsi',
                      k.deskripsi!,
                      accent,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color accent) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

// ===================== FORM VIEW =====================
class ActivityFormView extends GetView<ActivitiesController> {
  ActivityFormView({super.key});

  // GlobalKey untuk mengontrol validasi Form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isEdit = controller.selectedActivity.value != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Kegiatan' : 'Tambah Kegiatan',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withOpacity(0.05),
                blurRadius: 16,
              ),
            ],
          ),
          // ✅ Wrap dengan Form + GlobalKey agar validator berjalan
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  'NAMA KEGIATAN',
                  controller.namaCtrl,
                  'e.g. Rapat Bulanan RT',
                  Icons.event_note_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama kegiatan wajib diisi';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama kegiatan minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _label('JENIS KEGIATAN'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: controller.jenisCtrl.text.isNotEmpty
                      ? controller.jenisCtrl.text
                      : null,
                  items: const [
                    DropdownMenuItem(value: 'Rapat', child: Text('Rapat')),
                    DropdownMenuItem(value: 'Sosial', child: Text('Sosial')),
                    DropdownMenuItem(
                      value: 'Keamanan',
                      child: Text('Keamanan'),
                    ),
                    DropdownMenuItem(
                      value: 'Gotong Royong',
                      child: Text('Gotong Royong'),
                    ),
                    DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      controller.jenisCtrl.text = val;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis kegiatan wajib dipilih';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Pilih jenis kegiatan',
                    prefixIcon: const Icon(
                      Icons.category_rounded,
                      color: AppColors.outline,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _label('TANGGAL'),
                const SizedBox(height: 8),
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.pickTanggal(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: AppColors.outline,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat(
                              'dd MMMM yyyy',
                            ).format(controller.selectedTanggal.value),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _label('WAKTU'),
                const SizedBox(height: 8),
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.pickWaktu(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: AppColors.outline,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.selectedWaktu.value.format(context),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _field(
                  'LOKASI',
                  controller.lokasiCtrl,
                  'e.g. Balai RT 52',
                  Icons.place_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lokasi wajib diisi';
                    }
                    if (value.trim().length < 3) {
                      return 'Lokasi minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _label('Foto (OPSIONAL)'),
                const SizedBox(height: 8),

                Obx(
                  () => GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: controller.selectedImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusM,
                              ),
                              child: Image.file(
                                controller.selectedImage.value!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          // ✅ kalau edit & ada foto lama
                          : (controller.selectedActivity.value?.foto != null &&
                                controller
                                    .selectedActivity
                                    .value!
                                    .foto!
                                    .isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusM,
                              ),
                              child: Image.network(
                                controller.selectedActivity.value!.foto!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          // ✅ default kosong
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.image_outlined, size: 32),
                                SizedBox(height: 6),
                                Text('Tap untuk pilih foto'),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _label('DESKRIPSI'),
                const SizedBox(height: 8),
                // ✅ Ganti TextField → TextFormField agar validator berjalan
                TextFormField(
                  controller: controller.deskripsiCtrl,
                  maxLines: 4,
                  validator: (value) {
                    if (value != null && value.length > 200) {
                      return 'Deskripsi maksimal 200 karakter';
                    }
                    return null; // deskripsi boleh kosong
                  },
                  decoration: const InputDecoration(
                    hintText: 'Deskripsi kegiatan...',
                    prefixIcon: Icon(
                      Icons.notes_rounded,
                      color: AppColors.outline,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => GradientButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.saveActivity();
                      }
                    },
                    label: isEdit ? 'Simpan Perubahan' : 'Tambah Kegiatan',
                    isLoading: controller.isSubmitting.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(
    t,
    style: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: AppColors.secondary,
      letterSpacing: 1.2,
    ),
  );

  Widget _field(
    String label,
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    // ✅ Validator sekarang wajib diisi dari pemanggil, tidak hardcode di sini
    String? Function(String?)? validator,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      const SizedBox(height: 8),
      TextFormField(
        controller: ctrl,
        textInputAction: TextInputAction.next,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.outline),
        ),
      ),
    ],
  );
}
