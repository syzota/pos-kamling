import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

                  // LOGO
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.home_work_rounded,
                      color: Colors.white,
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== NIK =====
                        _label('NIK'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.nikCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '16 digit NIK',
                            prefixIcon: Icon(Icons.credit_card_rounded),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== TANGGAL LAHIR =====
                        _label('TANGGAL LAHIR'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(1990),
                              firstDate: DateTime(1940),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              controller.tglLahirCtrl.text = DateFormat(
                                'dd/MM/yyyy',
                              ).format(picked);
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: controller.tglLahirCtrl,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'DD/MM/YYYY',
                                prefixIcon: Icon(Icons.calendar_today_rounded),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ===== PASSWORD =====
                        _label('PASSWORD'),
                        const SizedBox(height: 8),
                        Obx(
                          () => TextField(
                            controller: controller.passwordCtrl,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              hintText: 'Min. 8 karakter',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: controller.togglePw,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== TERMS =====
                        Obx(
                          () => Row(
                            children: [
                              Checkbox(
                                value: controller.agreeTerms.value,
                                onChanged: (_) => controller.toggleTerms(),
                              ),
                              const Text("Setuju syarat & privasi"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ===== BUTTON =====
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
    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
  );
}
