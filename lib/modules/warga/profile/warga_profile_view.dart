import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../app/routes/app_routes.dart';
import 'warga_profile_controller.dart';

class WargaProfileView extends GetView<WargaProfileController> {
  const WargaProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final penduduk = controller.penduduk;
    final tanggalLahir = penduduk?.tanggalLahir;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        isAdmin: false,
        onTap: AppRoutes.navigateWargaBottomNav,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primaryFixed,
                    child: Icon(
                      Icons.person_rounded,
                      size: 42,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    penduduk?.nama ?? 'Nama Tidak Diketahui',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    penduduk?.nik ?? '-',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Data Kependudukan'),
            const SizedBox(height: 12),
            _buildReadOnlyField('NIK', penduduk?.nik ?? '-'),
            _buildReadOnlyField('Nama', penduduk?.nama ?? '-'),
            _buildReadOnlyField('Tempat Lahir', penduduk?.tempatLahir ?? '-'),
            _buildReadOnlyField(
              'Tanggal Lahir',
              tanggalLahir != null
                  ? '${tanggalLahir.day.toString().padLeft(2, '0')}/${tanggalLahir.month.toString().padLeft(2, '0')}/${tanggalLahir.year}'
                  : '-',
            ),
            _buildReadOnlyField('Jenis Kelamin', penduduk?.jenisKelamin ?? '-'),
            _buildReadOnlyField(
              'Status Perkawinan',
              penduduk?.statusPerkawinan ?? '-',
            ),
            _buildReadOnlyField('Agama', penduduk?.agama ?? '-'),
            _buildReadOnlyField(
              'Golongan Darah',
              penduduk?.golonganDarah ?? '-',
            ),
            _buildReadOnlyField('Pekerjaan', penduduk?.pekerjaan ?? '-'),
            _buildReadOnlyField(
              'Password',
              penduduk?.password != null ? '••••••••' : '-',
            ),
            const SizedBox(height: 28),
            Center(
              child: Obx(
                () => GradientButton(
                  label: 'Ganti Password',
                  icon: Icons.lock_reset_rounded,
                  isLoading: controller.isSubmitting.value,
                  onPressed: () => _showChangePasswordDialog(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurface,
      ),
    ),
  );

  Widget _buildReadOnlyField(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
          ),
        ),
      ],
    ),
  );

  void _showChangePasswordDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ganti Password',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: controller.oldPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password Lama'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.newPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password Baru'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.confirmPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientButton(
                      label: 'Simpan',
                      icon: Icons.check_rounded,
                      isLoading: controller.isSubmitting.value,
                      onPressed: controller.changePassword,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
