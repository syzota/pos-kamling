import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/settings_tile.dart';
import 'security_controller.dart';

class SecurityView extends GetView<SecurityController> {
  final bool isAdmin;
  const SecurityView({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Keamanan',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeroCard(context),
          const SizedBox(height: 24),

          SettingsSection(
            title: 'Akun',
            children: [
              SettingsTile(
                icon: Icons.lock_reset_rounded,
                title: 'Ganti Password',
                subtitle: 'Ubah kata sandi Anda',
                onTap: () => _showChangePasswordDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Obx(() {
            final available = controller.isBiometricAvailable.value;

            return SettingsSection(
              title: 'Autentikasi',
              children: [
                SettingsTile(
                  icon: Icons.fingerprint_rounded,
                  title: 'Sidik Jari',
                  subtitle: controller.biometricSubtitle.value,
                  iconColor: available
                      ? const Color(0xFF00BFA5)
                      : AppColors.outline,
                  trailing: available
                      ? Switch.adaptive(
                          value: controller.isBiometricEnabled.value,
                          activeColor: AppColors.primary,
                          onChanged: controller.toggleFingerprint,
                        )
                      : _badgeTidakTersedia(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akun Anda Aman',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Aktifkan Sidik Jari untuk login lebih cepat dan aman.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final requireOld = !isAdmin;

    Get.dialog(
      Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              const SizedBox(height: 4),
              Text(
                'Minimal 6 karakter',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 18),
              if (requireOld) ...[
                Obx(() => _passwordField(
                      controller: controller.oldPasswordCtrl,
                      label: 'Password Lama',
                      obscure: !controller.showOld.value,
                      onToggle: () =>
                          controller.showOld.value = !controller.showOld.value,
                    )),
                const SizedBox(height: 12),
              ],
              Obx(() => _passwordField(
                    controller: controller.newPasswordCtrl,
                    label: 'Password Baru',
                    obscure: !controller.showNew.value,
                    onToggle: () =>
                        controller.showNew.value = !controller.showNew.value,
                  )),
              const SizedBox(height: 12),
              Obx(() => _passwordField(
                    controller: controller.confirmPasswordCtrl,
                    label: 'Konfirmasi Password',
                    obscure: !controller.showConfirm.value,
                    onToggle: () => controller.showConfirm.value =
                        !controller.showConfirm.value,
                  )),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: Get.back,
                        child: const Text('Batal'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: Obx(() => GradientButton(
                            label: 'Simpan',
                            isLoading: controller.isSubmitting.value,
                            onPressed: () => controller.changePassword(
                              requireOldPassword: requireOld,
                            ),
                          )),
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

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _badgeTidakTersedia() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          'Tidak tersedia',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.outline,
          ),
        ),
      );
}