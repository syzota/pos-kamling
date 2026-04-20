import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../../core/widgets/gradient_button.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import 'package:file_picker/file_picker.dart';
import 'admin_letters_controller.dart';

class AdminLettersView extends GetView<AdminLettersController> {
  const AdminLettersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Kelola Surat',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.offAllNamed(AppRoutes.adminDashboard),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tinjau dan proses permohonan surat dari warga.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _filterChip('Semua', 'semua'),
                      const SizedBox(width: 8),
                      _filterChip('Diproses', 'diproses'),
                      const SizedBox(width: 8),
                      _filterChip('Ditolak', 'ditolak'),
                      const SizedBox(width: 8),
                      _filterChip('Selesai', 'disetujui'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              final list = controller.filteredSurat;
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.inbox_rounded,
                        size: 64,
                        color: AppColors.outlineVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tidak ada surat',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadSurat,
                color: AppColors.primary,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final s = list[i];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
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
                          Row(
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
                                child: Center(
                                  child: Text(
                                    (s.penduduk?.nama?.isNotEmpty == true)
                                        ? s.penduduk!.nama![0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      s.tanggalPengajuan != null
                                          ? DateFormat(
                                              'dd MMM yyyy, HH:mm',
                                            ).format(s.tanggalPengajuan!)
                                          : '',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _statusBadge(s.status),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusM,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.description_rounded,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        s.jenisSurat ?? 'Surat',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (s.keperluan != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '"${s.keperluan}"',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.secondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Tombol aksi hanya tampil jika status diajukan atau diproses
                          if (s.status == 'diajukan' || s.status == 'diproses')
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  // Tombol "Proses" hanya muncul saat status masih diajukan
                                  if (s.status == 'diajukan') ...[
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            controller.updateStatus(
                                              s.idSurat!,
                                              'diproses',
                                            ),
                                        child: const Text('Proses'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                  // Tombol "Setujui" — membuka dialog upload PDF
                                  Expanded(
                                    child: Obx(
                                      () => ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed:
                                            controller.isUploadingFor(
                                              s.idSurat!,
                                            )
                                            ? null
                                            : () => _showUploadDialog(
                                                context,
                                                s.idSurat!,
                                              ),
                                        child:
                                            controller.isUploadingFor(
                                              s.idSurat!,
                                            )
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : const Text('Setujui'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => controller.updateStatus(
                                        s.idSurat!,
                                        'ditolak',
                                      ),
                                      child: const Text('Tolak'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        isAdmin: true,
        onTap: AppRoutes.navigateAdminBottomNav,
      ),
    );
  }

  Widget _filterChip(String label, String value) => Obx(
    () => GestureDetector(
      onTap: () => controller.setFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: controller.filterStatus.value == value
              ? AppColors.primary
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withOpacity(0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: controller.filterStatus.value == value
                ? Colors.white
                : AppColors.secondary,
          ),
        ),
      ),
    ),
  );

  void _showUploadDialog(BuildContext context, int idSurat) {
    String? selectedFilePath;
    String? selectedFileName;
    Uint8List? selectedFileBytes;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Upload Surat",
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Upload file PDF untuk menyelesaikan surat",
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                const SizedBox(height: 12),

                TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: selectedFileName ?? '',
                  ),
                  decoration: InputDecoration(
                    hintText: "Pilih file PDF...",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                          withData: kIsWeb,
                        );

                        if (result != null && result.files.isNotEmpty) {
                          final file = result.files.single;

                          setState(() {
                            selectedFileName = file.name;
                            selectedFilePath = file.path;
                            selectedFileBytes = file.bytes;
                          });
                        }
                      },
                    ),
                  ),
                ),

                if (selectedFileName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            selectedFileName!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.green,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (selectedFileName == null ||
                      (selectedFileBytes == null &&
                          (selectedFilePath == null ||
                              selectedFilePath!.isEmpty))) {
                    Get.snackbar(
                      "Error",
                      "File belum dipilih",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  Navigator.of(context).pop();

                  await controller.approveWithFile(
                    idSurat: idSurat,
                    fileName: selectedFileName!,
                    filePath: selectedFilePath,
                    fileBytes: selectedFileBytes,
                  );
                },
                child: const Text("Kirim"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;
    String label;
    switch (status) {
      case 'disetujui':
        bg = AppColors.tertiaryFixed;
        text = AppColors.onTertiaryFixed;
        label = 'Disetujui';
        break;
      case 'ditolak':
        bg = AppColors.errorContainer;
        text = AppColors.onErrorContainer;
        label = 'Ditolak';
        break;
      case 'diproses':
        bg = AppColors.secondaryFixed;
        text = AppColors.onSecondaryFixed;
        label = 'Diproses';
        break;
      default:
        bg = AppColors.primaryFixed;
        text = AppColors.onPrimaryFixedVariant;
        label = 'Baru';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }
}
