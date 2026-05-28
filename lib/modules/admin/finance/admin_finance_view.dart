import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../app/routes/app_routes.dart';
import 'admin_finance_controller.dart';

class AdminFinanceView extends GetView<AdminFinanceController> {
  const AdminFinanceView({super.key});

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
          'Manajemen Keuangan',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openAddForm,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Tambah',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.loadTransactions,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroCard(),
                const SizedBox(height: 16),
                _buildSummaryCards(),
                const SizedBox(height: 24),
                _buildTransactionList(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        isAdmin: true,
        onTap: AppRoutes.navigateAdminBottomNav,
      ),
    );
  }

  Widget _buildHeroCard() => Obx(
    () => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'KAS RT',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Total Saldo',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white70,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.formatRpFull(controller.saldo.value),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.update_rounded, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Update: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildSummaryCards() => Obx(
    () => Row(
      children: [
        Expanded(
          child: _summaryCard(
            'PEMASUKAN',
            controller.formatRp(controller.totalPemasukan.value),
            AppColors.tertiary,
            Icons.trending_up_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            'PENGELUARAN',
            controller.formatRp(controller.totalPengeluaran.value),
            AppColors.error,
            Icons.trending_down_rounded,
          ),
        ),
      ],
    ),
  );

  Widget _summaryCard(
    String label,
    String value,
    Color accent,
    IconData icon,
  ) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border(left: BorderSide(color: accent, width: 4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withOpacity(0.05),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: accent, size: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

  Widget _buildTransactionList() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Riwayat Transaksi',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        'Geser kiri untuk hapus transaksi',
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondary),
      ),
      const SizedBox(height: 16),
      Obx(() {
        if (controller.transactions.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  size: 56,
                  color: AppColors.outlineVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada transaksi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap tombol Tambah untuk input transaksi',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          );
        }

        final sorted = controller.transactions.toList()
          ..sort((a, b) => b.tanggal!.compareTo(a.tanggal!));

        return Column(
          children: sorted.map((t) {
            final isPemasukan = t.isPemasukan;
            final accent = isPemasukan ? AppColors.tertiary : AppColors.error;

            return Dismissible(
              key: Key('tx_${t.idKeuangan}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete_rounded, color: Colors.red),
                    const SizedBox(height: 4),
                    Text(
                      'Hapus',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              confirmDismiss: (_) async {
                await controller.deleteTransaction(t);
                return false;
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border(
                    left: BorderSide(color: accent, width: 3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withOpacity(0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                      child: Icon(
                        isPemasukan
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.keterangan ??
                                (isPemasukan ? 'Pemasukan' : 'Pengeluaran'),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 10,
                                color: AppColors.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                t.tanggal != null
                                    ? DateFormat('dd MMM yyyy, HH:mm').format(t.tanggal!)
                                    : '-',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.outline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isPemasukan ? '+' : '-'} ${controller.formatRp(t.nominal ?? 0)}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isPemasukan ? 'MASUK' : 'KELUAR',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),
    ],
  );
}

class AdminFinanceFormView extends GetView<AdminFinanceController> {
  const AdminFinanceFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Tambah Transaksi',
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
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('JENIS TRANSAKSI'),
                const SizedBox(height: 8),
                Row(
                  children: ['pemasukan', 'pengeluaran'].map((jenis) {
                    final selected = controller.selectedJenis.value == jenis;
                    final color = jenis == 'pemasukan'
                        ? AppColors.tertiary
                        : AppColors.error;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectedJenis.value = jenis,
                        child: Container(
                          margin: EdgeInsets.only(
                            right: jenis == 'pemasukan' ? 8 : 0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selected
                                ? color
                                : AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM,
                            ),
                            border: selected
                                ? null
                                : Border.all(
                                    color: AppColors.outlineVariant,
                                  ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                jenis == 'pemasukan'
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                size: 16,
                                color: selected
                                    ? Colors.white
                                    : AppColors.secondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                jenis[0].toUpperCase() + jenis.substring(1),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                _label('TANGGAL'),
                const SizedBox(height: 8),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
                          controller.tanggalCtrl.text.isEmpty
                              ? 'Pilih tanggal'
                              : controller.tanggalCtrl.text,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: controller.tanggalCtrl.text.isEmpty
                                ? AppColors.outline
                                : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _label('NOMINAL (Rp)'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.nominalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Masukkan jumlah',
                    prefixIcon: const Icon(Icons.payments_outlined),
                    filled: true,
                    fillColor: AppColors.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _label('KETERANGAN'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.keteranganCtrl,
                  maxLines: 3,
                  maxLength: 200,
                  inputFormatters: [controller.emojiBlocker],
                  decoration: InputDecoration(
                    hintText: 'Deskripsi transaksi...',
                    prefixIcon: const Icon(Icons.notes_rounded),
                    filled: true,
                    fillColor: AppColors.surfaceContainerHigh,
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                GradientButton(
                  onPressed: controller.saveTransaction,
                  label: 'Simpan Transaksi',
                  isLoading: controller.isSubmitting.value,
                ),
              ],
            ),
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
}