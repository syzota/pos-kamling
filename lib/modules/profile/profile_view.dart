
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/info_tile.dart';
import '../../core/widgets/profile_header.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  static const double _tabletBreakpoint = 720;
  static const double _maxContentWidth = 720;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.primary,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _tabletBreakpoint;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: _buildScrollContent(context, isWide: isWide),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScrollContent(BuildContext context, {required bool isWide}) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Obx(() {
            final p = controller.pendudukRx.value;
            return ProfileHeader(
              nama: controller.displayName,
              nik: controller.displayNik,
              isAdmin: controller.isAdmin,
              photoFile: controller.photoFileRx.value,
              photoUrl: p?.fotoUrl,
              isUploading: controller.isUploadingPhoto.value, // ← tambah ini
              onPickFromCamera: controller.pickFromCamera,
              onPickFromGallery: controller.pickFromGallery,
            );
          }),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            isWide ? 32 : 20,
            24,
            isWide ? 32 : 20,
            32,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              _buildKependudukan(),
              const SizedBox(height: 24),
              _buildSettingsCard(context),
              const SizedBox(height: 16),
              _LogoutButton(onTap: () => _confirmLogout(context)),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildKependudukan() {
    return Obx(() {
      final p = controller.pendudukRx.value ?? controller.penduduk;
      final tgl = p?.tanggalLahir;
      final tglStr = tgl != null
          ? '${tgl.day.toString().padLeft(2, '0')}/'
            '${tgl.month.toString().padLeft(2, '0')}/'
            '${tgl.year}'
          : '-';

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(
            color: AppColors.outlineVariant.withOpacity(0.35),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Informasi Pribadi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.goToEditProfile,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Column(
              children: [
                InfoTile(
                  icon: Icons.badge_rounded,
                  label: 'NIK',
                  value: p?.nik ?? '-',
                ),
                InfoTile(
                  icon: Icons.location_on_rounded,
                  label: 'Tempat Lahir',
                  value: p?.tempatLahir ?? '-',
                ),
                InfoTile(
                  icon: Icons.cake_rounded,
                  label: 'Tanggal Lahir',
                  value: tglStr,
                ),
                InfoTile(
                  icon: Icons.timelapse_rounded,
                  label: 'Umur',
                  value: p?.umur != null ? '${p!.umur} tahun' : '-',
                ),
                InfoTile(
                  icon: Icons.wc_rounded,
                  label: 'Jenis Kelamin',
                  value: p?.jenisKelamin ?? '-',
                ),
                InfoTile(
                  icon: Icons.favorite_rounded,
                  label: 'Status Perkawinan',
                  value: p?.statusPerkawinan ?? '-',
                ),
                InfoTile(
                  icon: Icons.mosque_rounded,
                  label: 'Agama',
                  value: p?.agama ?? '-',
                ),
                InfoTile(
                  icon: Icons.bloodtype_rounded,
                  label: 'Golongan Darah',
                  value: p?.golonganDarah ?? '-',
                ),
                InfoTile(
                  icon: Icons.school_rounded,
                  label: 'Pendidikan Terakhir',
                  value: p?.pendidikanTerakhir ?? '-',
                ),
                InfoTile(
                  icon: Icons.work_rounded,
                  label: 'Pekerjaan',
                  value: p?.pekerjaan ?? '-',
                ),
                InfoTile(
                  icon: Icons.family_restroom_rounded,
                  label: 'Nama Ayah/Ibu',
                  value: p?.namaAyahIbu ?? '-',
                ),
                InfoTile(
                  icon: Icons.accessible_rounded,
                  label: 'Disabilitas',
                  value: p?.disabilitas ?? '-',
                ),
                InfoTile(
                  icon: Icons.phone_rounded,
                  label: 'No. Telepon',
                  value: p?.nomorTelepon ?? '-',
                ),
                InfoTile(
                  icon: Icons.home_rounded,
                  label: 'Alamat',
                  value: p?.alamat ?? '-',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          _SettingsLink(
            icon: Icons.lock_reset_rounded,
            iconColor: const Color(0xFF6C5CE7),
            title: 'Keamanan Akun',
            onTap: controller.goToSecurity,
          ),
          const _ThinDivider(),
          _SettingsLink(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.primary,
            title: 'Tentang Aplikasi',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'RT Digital',
              applicationVersion: '1.0.0',
              applicationLegalese: 'No. Telp/WhatsApp Admin: 08xxxxxxxxxx',
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        title: Text(
          'Keluar dari Akun?',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Anda akan keluar dari aplikasi.',
          style: GoogleFonts.inter(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text(
              'Keluar',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            letterSpacing: -0.2,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _AdminBadge extends StatelessWidget {
  const _AdminBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsLink extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _SettingsLink({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.6,
      indent: 54,
      color: AppColors.outlineVariant.withOpacity(0.4),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    const danger = Color(0xFFE53935);
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            border: Border.all(color: danger.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: danger.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.logout_rounded, color: danger, size: 20),
              ),
              const SizedBox(width: 14),
              Text(
                'Keluar dari Akun',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: danger,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
