
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/settings_tile.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  bool pengumuman = true;
  bool laporan = true;
  bool surat = true;
  bool suara = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pengumuman = prefs.getBool('notif_pengumuman') ?? true;
      laporan = prefs.getBool('notif_laporan') ?? true;
      surat = prefs.getBool('notif_surat') ?? true;
      suara = prefs.getBool('notif_suara') ?? true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SettingsSection(
              title: 'Jenis Notifikasi',
              children: [
                SettingsTile(
                  icon: Icons.campaign_rounded,
                  title: 'Pengumuman',
                  subtitle: 'Info pengumuman dari RT',
                  trailing: Switch.adaptive(
                    value: pengumuman,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      setState(() => pengumuman = v);
                      _save('notif_pengumuman', v);
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.report_rounded,
                  title: 'Laporan Warga',
                  subtitle: 'Update status laporan',
                  iconColor: const Color(0xFFFF9800),
                  trailing: Switch.adaptive(
                    value: laporan,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      setState(() => laporan = v);
                      _save('notif_laporan', v);
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.mail_rounded,
                  title: 'Surat Menyurat',
                  subtitle: 'Status pengajuan surat',
                  iconColor: const Color(0xFF7B61FF),
                  trailing: Switch.adaptive(
                    value: surat,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      setState(() => surat = v);
                      _save('notif_surat', v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              title: 'Preferensi',
              children: [
                SettingsTile(
                  icon: Icons.volume_up_rounded,
                  title: 'Suara Notifikasi',
                  subtitle: 'Bunyikan saat ada notifikasi',
                  iconColor: const Color(0xFF00BFA5),
                  trailing: Switch.adaptive(
                    value: suara,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      setState(() => suara = v);
                      _save('notif_suara', v);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
