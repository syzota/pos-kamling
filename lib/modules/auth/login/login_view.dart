import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB60059).withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_work_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Log In',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masuk sebagai warga RT 52',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.onSurface.withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),

                        // ===== NIK =====
                        _label('NIK'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.nikCtrl,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: '16 digit NIK',
                            prefixIcon: Icon(
                              Icons.credit_card_rounded,
                              color: AppColors.outline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ===== TANGGAL LAHIR =====
                        _label('TANGGAL LAHIR'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.tglLahirCtrl,
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(1990),
                              firstDate: DateTime(1940),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              final day = picked.day.toString().padLeft(2, '0');
                              final month = picked.month.toString().padLeft(
                                2,
                                '0',
                              );
                              final year = picked.year.toString();
                              controller.tglLahirCtrl.text =
                                  '$day/$month/$year';
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'DD/MM/YYYY',
                            prefixIcon: Icon(
                              Icons.calendar_today_rounded,
                              color: AppColors.outline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ===== PASSWORD =====
                        _label('PASSWORD'),
                        const SizedBox(height: 8),
                        Obx(
                          () => TextField(
                            controller: controller.passwordCtrl,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              hintText: 'Min. 8 karakter',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.outline,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.outline,
                                ),
                                onPressed: controller.togglePw,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Obx(
                          () => GestureDetector(
                            onTap: controller.toggleTerms,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: controller.agreeTerms.value
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: controller.agreeTerms.value
                                          ? AppColors.primary
                                          : AppColors.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: controller.agreeTerms.value
                                      ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.secondary,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Saya menyetujui ',
                                        ),
                                        TextSpan(
                                          text: 'Syarat Layanan',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const TextSpan(text: ' dan '),
                                        TextSpan(
                                          text: 'Kebijakan Privasi',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Obx(
                          () => GradientButton(
                            onPressed: controller.login,
                            label: 'Masuk',
                            isLoading: controller.isLoading.value,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
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
}
