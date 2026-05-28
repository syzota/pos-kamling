
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/models.dart';
import '../../data/providers/storage_provider.dart';
import '../constants/app_constants.dart';

class ProfileAvatarButton extends StatelessWidget {
  final double size;
  const ProfileAvatarButton({super.key, this.size = 38});

  @override
  Widget build(BuildContext context) {
    final penduduk = Get.isRegistered<PendudukModel>()
        ? Get.find<PendudukModel>()
        : null;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.profile),
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.25),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: _buildAvatar(penduduk),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(PendudukModel? p) {
    final image = _resolveImage(p);
    if (image != null) {
      return Image(image: image, fit: BoxFit.cover);
    }
    return Container(
      color: AppColors.primary.withOpacity(0.12),
      alignment: Alignment.center,
      child: Text(
        p?.inisialNama ?? '?',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }

  ImageProvider? _resolveImage(PendudukModel? p) {
    if (p == null) return null;

    if (!kIsWeb && p.idPenduduk != null) {
      final path = StorageProvider().read<String>('profile_photo_${p.idPenduduk}');
      if (path != null) {
        try {
          final f = File(path);
          if (f.existsSync()) return FileImage(f);
        } catch (_) {}
      }
    }

    if (p.fotoUrl != null && p.fotoUrl!.isNotEmpty) {
      return NetworkImage(p.fotoUrl!);
    }
    return null;
  }
}

