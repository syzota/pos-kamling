import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/gradient_button.dart';
import 'residents_controller.dart';
import '../../../data/models/models.dart';

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
            icon: const Icon(Icons.person_add_rounded, color: AppColors.primary),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
  );

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.people_outline_rounded, size: 64, color: AppColors.outlineVariant),
        const SizedBox(height: 12),
        Text(
          'Belum ada data warga',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.secondary,
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

  Widget _buildResidentCard(PendudukModel r) => GestureDetector(
    onTap: () => controller.openDetail(r),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(color: AppColors.onSurface.withOpacity(0.05), blurRadius: 10),
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
                  fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white,
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
                    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  r.nik ?? '-',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondary),
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
                      Flexible(child: _chip(r.pekerjaan!, AppColors.tertiaryFixed)),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.outline, size: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
    child: Text(
      label,
      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.onSurface),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

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

  Widget _buildHeader(PendudukModel r) => Container(
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
          decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
          child: Center(
            child: Text(
              (r.nama ?? '?')[0].toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          r.nama ?? '-',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white,
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

  Widget _buildInfoCard(PendudukModel r) => Container(
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
        _row(Icons.location_city_rounded, 'Tempat Lahir', r.tempatLahir ?? '-'),
        _row(
          Icons.cake_rounded, 'Tanggal Lahir',
          r.tanggalLahir != null
              ? DateFormat('dd MMMM yyyy').format(r.tanggalLahir!)
              : '-',
        ),
        _row(Icons.timelapse_rounded, 'Umur',
            r.umur != null ? '${r.umur} tahun' : '-'),
        _row(Icons.wc_rounded, 'Jenis Kelamin', r.jenisKelamin ?? '-'),
        _row(Icons.favorite_rounded, 'Status Perkawinan', r.statusPerkawinan ?? '-'),
        _row(Icons.mosque_rounded, 'Agama', r.agama ?? '-'),
        _row(Icons.bloodtype_rounded, 'Golongan Darah', r.golonganDarah ?? '-'),
        _row(Icons.school_rounded, 'Pendidikan', r.pendidikanTerakhir ?? '-'),
        _row(Icons.work_rounded, 'Pekerjaan', r.pekerjaan ?? '-'),
        _row(Icons.family_restroom_rounded, 'Nama Ayah/Ibu', r.namaAyahIbu ?? '-'),
        _row(Icons.accessible_rounded, 'Disabilitas', r.disabilitas ?? '-', isLast: true),
      ],
    ),
  );

  Widget _row(IconData icon, String label, String value, {bool isLast = false}) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 10),
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.secondary),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface,
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
              BoxShadow(color: AppColors.onSurface.withOpacity(0.05), blurRadius: 16),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('NIK'),
              const SizedBox(height: 8),
              TextField(
                controller: controller.nikCtrl,
                keyboardType: TextInputType.number,
                maxLength: 16,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                decoration: _inputDeco('16 digit NIK', Icons.credit_card_rounded),
              ),
              const SizedBox(height: 14),
              _label('NAMA LENGKAP'),
              const SizedBox(height: 8),
              TextField(
                controller: controller.namaCtrl,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDeco('Nama sesuai KTP', Icons.person_outline_rounded),
              ),
              const SizedBox(height: 14),
              _label('TEMPAT LAHIR'),
              const SizedBox(height: 8),
              TextField(
                controller: controller.tempatLahirCtrl,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDeco('Kota tempat lahir', Icons.location_city_rounded),
              ),
              const SizedBox(height: 14),
              _label('TANGGAL LAHIR'),
              const SizedBox(height: 8),
              Obx(() => GestureDetector(
                onTap: () => controller.pickTanggalLahir(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.outline),
                      const SizedBox(width: 10),
                      Text(
                        controller.selectedTanggalLahir.value != null
                            ? DateFormat('dd MMMM yyyy').format(controller.selectedTanggalLahir.value!)
                            : 'Pilih tanggal lahir',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: controller.selectedTanggalLahir.value != null
                              ? AppColors.onSurface
                              : AppColors.outline,
                        ),
                      ),
                      const Spacer(),
                      if (controller.selectedTanggalLahir.value != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${controller.selectedTanggalLahir.value != null ? _hitungUmur(controller.selectedTanggalLahir.value!) : 0} tahun',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 14),
              _label('JENIS KELAMIN'),
              const SizedBox(height: 8),
              Obx(() => Row(
                children: ResidentsController.jenisKelaminOptions.map((jk) {
                  final selected = controller.selectedJenisKelamin.value == jk;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectedJenisKelamin.value = jk,
                      child: Container(
                        margin: EdgeInsets.only(
                          right: jk == 'Laki-laki' ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: selected ? null : Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              jk == 'Laki-laki' ? Icons.male_rounded : Icons.female_rounded,
                              size: 16,
                              color: selected ? Colors.white : AppColors.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              jk,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
              const SizedBox(height: 14),
              _label('STATUS PERKAWINAN'),
              const SizedBox(height: 8),
              Obx(() => _dropdown<String>(
                value: controller.selectedStatusPerkawinan.value,
                items: ResidentsController.statusPerkawinanOptions,
                hint: 'Pilih status perkawinan',
                icon: Icons.favorite_rounded,
                onChanged: (v) => controller.selectedStatusPerkawinan.value = v,
              )),
              const SizedBox(height: 14),
              _label('AGAMA'),
              const SizedBox(height: 8),
              Obx(() => _dropdown<String>(
                value: controller.selectedAgama.value,
                items: ResidentsController.agamaOptions,
                hint: 'Pilih agama',
                icon: Icons.mosque_rounded,
                onChanged: (v) => controller.selectedAgama.value = v,
              )),
              const SizedBox(height: 14),
              _label('GOLONGAN DARAH'),
              const SizedBox(height: 8),
              Obx(() => _dropdown<String>(
                value: controller.selectedGolonganDarah.value,
                items: ResidentsController.golonganDarahOptions,
                hint: 'Pilih golongan darah',
                icon: Icons.bloodtype_rounded,
                onChanged: (v) => controller.selectedGolonganDarah.value = v,
              )),
              const SizedBox(height: 14),
              _label('PENDIDIKAN TERAKHIR'),
              const SizedBox(height: 8),
              Obx(() => _dropdown<String>(
                value: controller.selectedPendidikan.value,
                items: ResidentsController.pendidikanOptions,
                hint: 'Pilih pendidikan terakhir',
                icon: Icons.school_rounded,
                onChanged: (v) => controller.selectedPendidikan.value = v,
              )),
              const SizedBox(height: 14),
              _label('PEKERJAAN'),
              const SizedBox(height: 8),
              Obx(() => _dropdown<String>(
                value: controller.selectedPekerjaan.value,
                items: ResidentsController.pekerjaanOptions,
                hint: 'Pilih pekerjaan',
                icon: Icons.work_rounded,
                onChanged: (v) => controller.selectedPekerjaan.value = v,
              )),
              const SizedBox(height: 14),
              _label('NAMA AYAH / IBU'),
              const SizedBox(height: 8),
              TextField(
                controller: controller.namaAyahIbuCtrl,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDeco('Nama orang tua', Icons.family_restroom_rounded),
              ),
              const SizedBox(height: 14),
              _label('DISABILITAS'),
              const SizedBox(height: 8),
              Obx(() => _dropdown<String>(
                value: controller.selectedDisabilitas.value,
                items: ResidentsController.disabilitasOptions,
                hint: 'Pilih kondisi disabilitas',
                icon: Icons.accessible_rounded,
                onChanged: (v) => controller.selectedDisabilitas.value = v,
              )),

              const SizedBox(height: 28),
              Obx(() => GradientButton(
                onPressed: controller.saveResident,
                label: isEdit ? 'Simpan Perubahan' : 'Tambah Warga',
                isLoading: controller.isSubmitting.value,
              )),
            ],
          ),
        ),
      ),
    );
  }

  int _hitungUmur(DateTime tanggalLahir) {
    final now = DateTime.now();
    int umur = now.year - tanggalLahir.year;
    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      umur--;
    }
    return umur;
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

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, color: AppColors.outline, size: 20),
    filled: true,
    fillColor: AppColors.surfaceContainerHigh,
    counterText: '',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      borderSide: BorderSide.none,
    ),
  );

  Widget _dropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required IconData icon,
    required ValueChanged<T?> onChanged,
  }) =>
      DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.outline),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.outline, size: 20),
          filled: true,
          fillColor: AppColors.surfaceContainerHigh,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        items: items
            .map((e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    e.toString(),
                    style: GoogleFonts.inter(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      );
}