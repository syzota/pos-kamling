import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class ProfileHeader extends StatelessWidget {
  final String nama;
  final String nik;
  final bool isAdmin;
  final File? photoFile;
  final String? photoUrl;
  final bool isUploading;
  final VoidCallback onPickFromCamera;
  final VoidCallback onPickFromGallery;

  const ProfileHeader({
    super.key,
    required this.nama,
    required this.nik,
    required this.isAdmin,
    this.photoFile,
    this.photoUrl,
    this.isUploading = false,
    required this.onPickFromCamera,
    required this.onPickFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.85),
            AppColors.primaryFixed,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: 'profile-avatar',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: isUploading
                            ? null
                            : _buildImageProvider(),
                        child: _buildImageProvider() == null || isUploading
                            ? Icon(
                                isAdmin
                                    ? Icons.manage_accounts_rounded
                                    : Icons.person_rounded,
                                size: 50,
                                color: AppColors.primary.withOpacity(
                                  isUploading ? 0.3 : 1,
                                ),
                              )
                            : null,
                      ),
                      if (isUploading)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: isUploading
                      ? null
                      : () => _showPhotoPickerSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isUploading
                          ? Colors.grey.shade300
                          : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isUploading
                          ? Icons.hourglass_top_rounded
                          : Icons.camera_alt_rounded,
                      size: 18,
                      color: isUploading
                          ? Colors.grey.shade500
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            nama,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'NIK: $nik',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withOpacity(0.85),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAdmin
                      ? Icons.shield_rounded
                      : Icons.verified_user_rounded,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  isAdmin ? 'Administrator' : 'Warga',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _buildImageProvider() {
    if (photoFile != null) return FileImage(photoFile!);
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return NetworkImage(photoUrl!);
    }
    return null;
  }

  void _showPhotoPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ubah Foto Profil',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              _photoOption(
                icon: Icons.camera_alt_rounded,
                label: 'Ambil dari Kamera',
                onTap: () {
                  Navigator.pop(ctx);
                  onPickFromCamera();
                },
              ),
              _photoOption(
                icon: Icons.photo_library_rounded,
                label: 'Pilih dari Galeri',
                onTap: () {
                  Navigator.pop(ctx);
                  onPickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}