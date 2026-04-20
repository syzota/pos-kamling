import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/gradient_button.dart';
import 'residents_controller.dart';

class ResidentsView extends GetView<ResidentsController> {
  const ResidentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.offAllNamed(AppRoutes.adminDashboard),
        ),
        title: Text(
          'Data Warga',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_rounded,
              color: AppColors.primary,
            ),
            onPressed: controller.openAdd,
            tooltip: 'Tambah Warga',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (controller.filteredResidents.isEmpty) {
                return _buildEmpty();
              }
              return RefreshIndicator(
                onRefresh: controller.loadResidents,
                color: AppColors.primary,
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.filteredResidents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) =>
                      _buildResidentCard(controller.filteredResidents[i]),
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        isAdmin: true,
        onTap: AppRoutes.navigateAdminBottomNav,
      ),
    );
  }

  Widget _buildSearchBar() => Container(
    color: AppColors.surfaceContainerLowest,
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
    child: TextField(
      onChanged: controller.onSearch,
      decoration: InputDecoration(
        hintText: 'Cari nama, NIK, atau pekerjaan...',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.outline),
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    ),
  );

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.people_outline_rounded,
          size: 64,
          color: AppColors.outlineVariant,
        ),
        const SizedBox(height: 12),
        Text(
          'Belum ada data warga',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap tombol + untuk menambah warga',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: controller.openAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Warga'),
        ),
      ],
    ),
  );

  Widget _buildResidentCard(r) => GestureDetector(
    onTap: () => controller.openDetail(r),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (r.nama ?? '?')[0].toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.nama ?? '-',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  r.nik ?? '-',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _chip(
                      r.jenisKelamin ?? '-',
                      r.jenisKelamin == 'Perempuan'
                          ? AppColors.secondaryFixed
                          : AppColors.primaryFixed,
                    ),
                    const SizedBox(width: 6),
                    if (r.pekerjaan != null)
                      _chip(r.pekerjaan!, AppColors.tertiaryFixed),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.outline,
              size: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (val) {
              if (val == 'edit') controller.openEdit(r);
              if (val == 'delete') controller.deleteResident(r);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _chip(String label, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
    ),
  );
}

// ===================== DETAIL VIEW =====================
class ResidentDetailView extends GetView<ResidentsController> {
  const ResidentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = controller.selectedResident.value!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Warga',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
            onPressed: () => controller.openEdit(r),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(r),
            const SizedBox(height: 20),
            _buildInfoCard(r),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(r) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
    ),
    child: Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              (r.nama ?? '?')[0].toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          r.nama ?? '-',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'NIK: ${r.nik ?? '-'}',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
        ),
      ],
    ),
  );

  Widget _buildInfoCard(r) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      boxShadow: [
        BoxShadow(color: AppColors.onSurface.withOpacity(0.05), blurRadius: 16),
      ],
    ),
    child: Column(
      children: [
        _row('Tempat Lahir', r.tempatLahir ?? '-'),
        _row(
          'Tanggal Lahir',
          r.tanggalLahir != null
              ? DateFormat('dd MMMM yyyy').format(r.tanggalLahir!)
              : '-',
        ),
        _row('Umur', '${r.umur ?? '-'} tahun'),
        _row('Jenis Kelamin', r.jenisKelamin ?? '-'),
        _row('Status Perkawinan', r.statusPerkawinan ?? '-'),
        _row('Agama', r.agama ?? '-'),
        _row('Golongan Darah', r.golonganDarah ?? '-'),
        _row('Pendidikan', r.pendidikanTerakhir ?? '-'),
        _row('Pekerjaan', r.pekerjaan ?? '-'),
        _row('Nama Ayah/Ibu', r.namaAyahIbu ?? '-'),
        _row('Disabilitas', r.disabilitas ?? '-', isLast: true),
      ],
    ),
  );

  Widget _row(String label, String value, {bool isLast = false}) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.secondary,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
      if (!isLast) const Divider(height: 1, color: AppColors.outlineVariant),
    ],
  );
}

// ===================== FORM VIEW =====================
class ResidentFormView extends GetView<ResidentsController> {
  const ResidentFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEdit = controller.selectedResident.value != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Data Warga' : 'Tambah Warga Baru',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withOpacity(0.05),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                'NIK',
                controller.nikCtrl,
                '16 digit NIK',
                Icons.credit_card_rounded,
                type: TextInputType.number,
              ),
              const SizedBox(height: 14),
              _field(
                'NAMA LENGKAP',
                controller.namaCtrl,
                'Nama sesuai KTP',
                Icons.person_outline_rounded,
              ),
              const SizedBox(height: 14),
              _field(
                'TEMPAT LAHIR',
                controller.tempatLahirCtrl,
                'Kota tempat lahir',
                Icons.location_city_rounded,
              ),
              const SizedBox(height: 14),
              _label('TANGGAL LAHIR'),
              const SizedBox(height: 8),
              Obx(
                () => GestureDetector(
                  onTap: () => controller.pickTanggalLahir(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: AppColors.outline,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          controller.selectedTanggalLahir.value != null
                              ? DateFormat(
                                  'dd MMMM yyyy',
                                ).format(controller.selectedTanggalLahir.value!)
                              : 'Pilih tanggal lahir',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: controller.selectedTanggalLahir.value != null
                                ? AppColors.onSurface
                                : AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _label('UMUR'),
              const SizedBox(height: 8),

              Obx(
                () => TextField(
                  controller: controller.umurCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: controller.selectedTanggalLahir.value == null
                        ? 'Pilih tanggal lahir dulu'
                        : 'Umur otomatis terisi',
                    prefixIcon: const Icon(
                      Icons.cake_rounded,
                      color: AppColors.outline,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _label('JENIS KELAMIN'),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: ['Laki-laki', 'Perempuan'].map((jk) {
                    final selected =
                        controller.selectedJenisKelamin.value == jk;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectedJenisKelamin.value = jk,
                        child: Container(
                          margin: EdgeInsets.only(
                            right: jk == 'Laki-laki' ? 8 : 0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              jk,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              _label('STATUS PERKAWINAN'),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: controller.selectedStatusPerkawinan.value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                  items: ['belum', 'kawin', 'cerai']
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.capitalizeFirst!), // biar tetap rapi
                        ),
                      )
                      .toList(),
                  onChanged: (v) =>
                      controller.selectedStatusPerkawinan.value = v,
                ),
              ),
              const SizedBox(height: 14),
              _label('AGAMA'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: controller.agamaCtrl.text.isEmpty
                    ? null
                    : controller.agamaCtrl.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
                hint: const Text('Pilih Agama'),
                items:
                    [
                          'Islam',
                          'Kristen',
                          'Katolik',
                          'Hindu',
                          'Buddha',
                          'Konghucu',
                          'Lainnya',
                        ]
                        .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                        .toList(),
                onChanged: (v) => controller.agamaCtrl.text = v ?? '',
              ),
              const SizedBox(height: 14),
              _label('GOLONGAN DARAH'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: controller.golonganDarahCtrl.text.isEmpty
                    ? null
                    : controller.golonganDarahCtrl.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
                hint: const Text('Pilih Golongan Darah'),
                items: ['A', 'B', 'AB', 'O', 'Lainnya']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => controller.golonganDarahCtrl.text = v ?? '',
              ),
              const SizedBox(height: 14),
              _field(
                'PENDIDIKAN TERAKHIR',
                controller.pendidikanCtrl,
                'e.g. SMA, S1',
                Icons.school_outlined,
              ),
              const SizedBox(height: 14),
              _field(
                'PEKERJAAN',
                controller.pekerjaanCtrl,
                'e.g. Wiraswasta',
                Icons.work_outline_rounded,
              ),
              const SizedBox(height: 14),
              _field(
                'NAMA AYAH/IBU',
                controller.namaAyahIbuCtrl,
                'Nama orang tua',
                Icons.family_restroom_rounded,
              ),
              const SizedBox(height: 14),
              _field(
                'DISABILITAS',
                controller.disabilitasCtrl,
                'Kosongkan jika tidak ada',
                Icons.accessibility_rounded,
              ),
              const SizedBox(height: 24),
              Obx(
                () => GradientButton(
                  onPressed: controller.saveResident,
                  label: isEdit ? 'Simpan Perubahan' : 'Tambah Warga',
                  isLoading: controller.isSubmitting.value,
                ),
              ),
            ],
          ),
        ),
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

  Widget _field(
    String label,
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType? type,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      const SizedBox(height: 8),
      TextField(
        controller: ctrl,
        keyboardType: type,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.outline),
        ),
      ),
    ],
  );
}
