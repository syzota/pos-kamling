import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  static const _maxWidth = 720.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        actions: [
          if (controller.isAdmin)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_rounded, size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Admin',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!controller.isAdmin) const _WargaInfoBanner(),
                if (!controller.isAdmin) const SizedBox(height: 16),

                const _SectionLabel('Data Utama'),
                const SizedBox(height: 12),

                _LabeledField(
                  label: 'Nama Lengkap',
                  isLocked: !controller.canEditNama,
                  child: _modernTextField(
                    ctrl: controller.namaCtrl,
                    hint: 'Masukkan nama lengkap',
                    icon: Icons.person_rounded,
                    enabled: controller.canEditNama,
                    formatters: controller.canEditNama
                        ? [controller.emojiBlocker]
                        : null,
                    capitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'NIK',
                  isLocked: !controller.canEditNik,
                  child: _modernTextField(
                    ctrl: controller.nikCtrl,
                    hint: '16 digit NIK',
                    icon: Icons.badge_rounded,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    enabled: controller.canEditNik,
                    formatters: controller.canEditNik
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : null,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Tempat Lahir',
                        isLocked: !controller.canEditTempatLahir,
                        child: _modernTextField(
                          ctrl: controller.tempatLahirCtrl,
                          hint: 'Kota lahir',
                          icon: Icons.location_on_rounded,
                          enabled: controller.canEditTempatLahir,
                          formatters: controller.canEditTempatLahir
                              ? [controller.emojiBlocker]
                              : null,
                          capitalization: TextCapitalization.words,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'Tanggal Lahir',
                        isLocked: !controller.canEditTanggalLahir,
                        child: GestureDetector(
                          onTap: controller.canEditTanggalLahir
                              ? () => controller.pickTanggalLahir(context)
                              : null,
                          child: AbsorbPointer(
                            child: _modernTextField(
                              ctrl: controller.tanggalLahirCtrl,
                              hint: 'DD/MM/YYYY',
                              icon: Icons.calendar_today_rounded,
                              enabled: controller.canEditTanggalLahir,
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Jenis Kelamin',
                  isLocked: !controller.canEditJenisKelamin,
                  child: Obx(() => _modernDropdown<String>(
                    value: controller.jenisKelaminRx.value,
                    items: EditProfileController.jenisKelaminOptions,
                    hint: 'Pilih jenis kelamin',
                    icon: Icons.wc_rounded,
                    enabled: controller.canEditJenisKelamin,
                    onChanged: (v) => controller.jenisKelaminRx.value = v,
                  )),
                ),

                const SizedBox(height: 28),
                const _SectionLabel('Data Tambahan'),
                const SizedBox(height: 12),

                _LabeledField(
                  label: 'Agama',
                  child: Obx(() => _modernDropdown<String>(
                    value: controller.agamaRx.value,
                    items: EditProfileController.agamaOptions,
                    hint: 'Pilih agama',
                    icon: Icons.mosque_rounded,
                    enabled: true,
                    onChanged: (v) => controller.agamaRx.value = v,
                  )),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Status Perkawinan',
                  child: Obx(() => _modernDropdown<String>(
                    value: controller.statusPerkawinanRx.value,
                    items: EditProfileController.statusPerkawinanOptions,
                    hint: 'Pilih status perkawinan',
                    icon: Icons.favorite_rounded,
                    enabled: true,
                    onChanged: (v) => controller.statusPerkawinanRx.value = v,
                  )),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Golongan Darah',
                  isLocked: !controller.canEditGolonganDarah,
                  child: Obx(() => _modernDropdown<String>(
                    value: controller.golonganDarahRx.value,
                    items: EditProfileController.golonganDarahOptions,
                    hint: 'Pilih golongan darah',
                    icon: Icons.bloodtype_rounded,
                    enabled: controller.canEditGolonganDarah,
                    onChanged: (v) => controller.golonganDarahRx.value = v,
                  )),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Pekerjaan',
                  child: Obx(() => _modernDropdown<String>(
                    value: controller.pekerjaanRx.value,
                    items: EditProfileController.pekerjaanOptions,
                    hint: 'Pilih pekerjaan',
                    icon: Icons.work_rounded,
                    enabled: true,
                    onChanged: (v) => controller.pekerjaanRx.value = v,
                  )),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Pendidikan Terakhir',
                  child: Obx(() => _modernDropdown<String>(
                    value: controller.pendidikanTerakhirRx.value,
                    items: EditProfileController.pendidikanOptions,
                    hint: 'Pilih pendidikan terakhir',
                    icon: Icons.school_rounded,
                    enabled: true,
                    onChanged: (v) => controller.pendidikanTerakhirRx.value = v,
                  )),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Nama Ayah / Ibu',
                  child: _modernTextField(
                    ctrl: controller.namaAyahIbuCtrl,
                    hint: 'Nama orang tua',
                    icon: Icons.family_restroom_rounded,
                    enabled: true,
                    formatters: [controller.emojiBlocker],
                    capitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Disabilitas',
                  child: Obx(() => _modernDropdown<String>(
                    value: controller.disabilitasRx.value,
                    items: EditProfileController.disabilitasOptions,
                    hint: 'Pilih kondisi disabilitas',
                    icon: Icons.accessible_rounded,
                    enabled: true,
                    onChanged: (v) => controller.disabilitasRx.value = v,
                  )),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Nomor Telepon',
                  child: _modernTextField(
                    ctrl: controller.teleponCtrl,
                    hint: '08xxxxxxxxxx (min. 6 angka)',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    enabled: true,
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d+]')),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                _LabeledField(
                  label: 'Alamat',
                  child: _modernTextField(
                    ctrl: controller.alamatCtrl,
                    hint: 'Alamat tempat tinggal',
                    icon: Icons.home_rounded,
                    maxLines: 3,
                    enabled: true,
                    formatters: [controller.emojiBlocker],
                  ),
                ),

                const SizedBox(height: 32),
                Obx(() => GradientButton(
                  label: 'Simpan Perubahan',
                  icon: Icons.save_rounded,
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.simpan,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernTextField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    bool enabled = true,
    bool readOnly = false,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      textCapitalization: capitalization,
      textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: enabled ? AppColors.onSurface : AppColors.outline,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.outline),
        prefixIcon: Icon(
          icon,
          color: enabled ? AppColors.primary : AppColors.outline,
          size: 20,
        ),
        counterText: '',
        filled: true,
        fillColor: enabled
            ? AppColors.surfaceContainerLowest
            : AppColors.surfaceContainerLow.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: BorderSide(color: AppColors.outlineVariant.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _modernDropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required IconData icon,
    required bool enabled,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: enabled ? AppColors.primary : AppColors.outline,
      ),
      items: items.map((e) => DropdownMenuItem<T>(
        value: e,
        child: Text(
          e.toString(),
          style: GoogleFonts.inter(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      )).toList(),
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.outline),
        prefixIcon: Icon(
          icon,
          color: enabled ? AppColors.primary : AppColors.outline,
          size: 20,
        ),
        filled: true,
        fillColor: enabled
            ? AppColors.surfaceContainerLowest
            : AppColors.surfaceContainerLow.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: BorderSide(color: AppColors.outlineVariant.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.secondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isLocked;

  const _LabeledField({
    required this.label,
    required this.child,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              if (isLocked) ...[
                const SizedBox(width: 6),
                const Icon(Icons.lock_rounded, size: 12, color: AppColors.outline),
                const SizedBox(width: 4),
                Text(
                  'Hanya admin',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _WargaInfoBanner extends StatelessWidget {
  const _WargaInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Beberapa data tidak dapat diubah',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIK, tempat & tanggal lahir, serta jenis kelamin '
                  'hanya dapat diubah oleh admin RT. Hubungi admin '
                  'jika ada kesalahan data.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.5,
                    color: AppColors.onSurface.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}