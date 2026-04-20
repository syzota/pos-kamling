import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'letter_controller.dart';

class LetterView extends GetView<LetterController> {
  const LetterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Layanan Surat',
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
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajukan Surat Baru',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Ajukan dokumen kependudukan dan pantau statusnya secara real-time.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFormCard(),
                    const SizedBox(height: 28),
                    _buildRiwayat(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        isAdmin: false,
        onTap: AppRoutes.navigateWargaBottomNav,
      ),
    );
  }

  Widget _buildFormCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      boxShadow: [
        BoxShadow(color: AppColors.onSurface.withOpacity(0.06), blurRadius: 20),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.edit_document, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'Form Pengajuan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'JENIS SURAT',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedJenisSurat.value.isEmpty
                    ? null
                    : controller.selectedJenisSurat.value,
                isExpanded: true,
                hint: Text(
                  'Pilih jenis surat...',
                  style: GoogleFonts.inter(
                    color: AppColors.outline,
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(
                  Icons.expand_more_rounded,
                  color: AppColors.outline,
                ),
                items: AppStrings.suratTypes
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                          s,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.selectedJenisSurat.value = v;
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'KEPERLUAN',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.keperluanCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Contoh: Persyaratan pembuatan paspor',
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => GradientButton(
            onPressed: controller.ajukanSurat,
            label: 'Kirim Pengajuan',
            icon: Icons.send_rounded,
            isLoading: controller.isSubmitting.value,
          ),
        ),
      ],
    ),
  );

  Widget _buildRiwayat() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Status Pengajuan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Obx(() {
        if (controller.riwayatSurat.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.drafts_rounded,
                  size: 40,
                  color: AppColors.outlineVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  'Belum ada pengajuan surat',
                  style: GoogleFonts.inter(color: AppColors.secondary),
                ),
              ],
            ),
          );
        }
        return Column(
          children: controller.riwayatSurat.map((s) {
            IconData icon;
            Color iconColor;
            switch (s.status) {
              case 'disetujui':
                icon = Icons.verified_rounded;
                iconColor = AppColors.tertiary;
                break;
              case 'ditolak':
                icon = Icons.cancel_rounded;
                iconColor = AppColors.error;
                break;
              case 'diproses':
                icon = Icons.autorenew_rounded;
                iconColor = AppColors.secondary;
                break;
              default:
                icon = Icons.hourglass_empty_rounded;
                iconColor = AppColors.outline;
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withOpacity(0.04),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                        child: Icon(icon, color: iconColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.jenisSurat ?? 'Surat',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              s.tanggalPengajuan != null
                                  ? DateFormat(
                                      'dd MMM yyyy',
                                    ).format(s.tanggalPengajuan!)
                                  : '',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _statusChip(s.status),
                    ],
                  ),
                  if (s.status == 'disetujui' &&
                      (s.fileUrl?.trim().isNotEmpty ?? false)) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryFixed.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf_rounded,
                            color: AppColors.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'PDF surat sudah tersedia. Warga bisa menerima surat dan mengunduh file.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => OutlinedButton.icon(
                              onPressed:
                                  controller.isProcessingSurat(s.idSurat!)
                                  ? null
                                  : () => controller.terimaSurat(s),
                              icon: controller.isProcessingSurat(s.idSurat!)
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.mark_email_read_rounded),
                              label: const Text('Terima Surat'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(
                            () => ElevatedButton.icon(
                              onPressed:
                                  controller.isProcessingSurat(s.idSurat!)
                                  ? null
                                  : () => controller.downloadSurat(s),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              icon: controller.isProcessingSurat(s.idSurat!)
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.download_rounded),
                              label: const Text('Download PDF'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (s.status == 'disetujui') ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryFixed.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                      child: Text(
                        'Surat sudah disetujui, tetapi file PDF belum diunggah admin.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      }),
    ],
  );

  Widget _statusChip(String status) {
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
        label = 'Diajukan';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: text,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
