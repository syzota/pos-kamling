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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: controller.openAddForm,
            tooltip: 'Tambah Transaksi',
          ),
        ],
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
                const SizedBox(height: 80),
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
          Text(
            'TOTAL SALDO KAS RT',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.formatRpFull(controller.saldo.value),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Update: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
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
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      border: Border(left: BorderSide(color: accent, width: 4)),
      boxShadow: [
        BoxShadow(color: AppColors.onSurface.withOpacity(0.05), blurRadius: 12),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(icon, color: accent, size: 18),
          ],
        ),
      ],
    ),
  );

  Widget _buildTransactionList() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Riwayat Transaksi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          GestureDetector(
            onTap: controller.openAddForm,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '+ Tambah',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Obx(() {
        if (controller.transactions.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  size: 48,
                  color: AppColors.outlineVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  'Belum ada transaksi',
                  style: GoogleFonts.inter(color: AppColors.secondary),
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
            return Dismissible(
              key: Key('tx_${t.idKeuangan}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.red),
              ),
              confirmDismiss: (_) async {
                await controller.deleteTransaction(t);
                return false;
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border(
                    left: BorderSide(
                      color: isPemasukan ? AppColors.tertiary : AppColors.error,
                      width: 3,
                    ),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isPemasukan
                            ? AppColors.tertiaryFixed
                            : AppColors.errorContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPemasukan
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: isPemasukan
                            ? AppColors.tertiary
                            : AppColors.error,
                        size: 18,
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
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t.tanggal != null
                                ? DateFormat(
                                    'dd MMM yy, HH:mm:ss',
                                  ).format(t.tanggal!)
                                : '-',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isPemasukan ? '+' : '-'} ${controller.formatRp(t.nominal ?? 0)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isPemasukan
                            ? AppColors.tertiary
                            : AppColors.error,
                      ),
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

// ===================== FORM VIEW =====================
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
                          ),
                          child: Center(
                            child: Text(
                              jenis[0].toUpperCase() + jenis.substring(1),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
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

                const SizedBox(height: 16),
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
                          controller.tanggalCtrl.text.isEmpty
                              ? 'Pilih tanggal'
                              : controller.tanggalCtrl.text,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _label('NOMINAL (Rp)'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.nominalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan jumlah',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                ),

                const SizedBox(height: 16),
                _label('KETERANGAN'),
                const SizedBox(height: 8),

                TextField(
                  controller: controller.keteranganCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Deskripsi transaksi...',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),

                const SizedBox(height: 24),

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
