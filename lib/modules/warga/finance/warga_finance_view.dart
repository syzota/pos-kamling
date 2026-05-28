import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import 'warga_finance_controller.dart';

class WargaFinanceView extends GetView<WargaFinanceController> {
  const WargaFinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.offAllNamed(AppRoutes.wargaDashboard),
        ),
        title: Text(
          'Transparansi Kas RT',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.surfaceContainerLowest.withOpacity(0.95),
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : RefreshIndicator(
                onRefresh: controller.loadData,
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
                      const SizedBox(height: 16),
                      _buildInfoNote(),
                      const SizedBox(height: 24),
                      _buildTransaksiList(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        isAdmin: false,
        onTap: AppRoutes.navigateWargaBottomNav,
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
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.visibility_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Hanya Lihat',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Total Saldo Kas',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.update_rounded,
                  color: Colors.white,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  'Update: ${DateFormat('MMMM yyyy').format(DateTime.now())}',
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

  Widget _buildInfoNote() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.06),
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      border: Border.all(color: AppColors.primary.withOpacity(0.15)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_rounded, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Data keuangan diperbarui oleh Bendahara RT. '
            'Setiap warga berhak meminta rincian nota belanja kepada admin.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.secondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildTransaksiList() => Column(
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
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${controller.transactions.length} transaksi',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          )),
        ],
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
              ],
            ),
          );
        }

        return Column(
          children: controller.transactions.map((t) {
            final isPemasukan = t.isPemasukan;
            final accent =
                isPemasukan ? AppColors.tertiary : AppColors.error;

            return Container(
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
                    blurRadius: 10,
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
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
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
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
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
                                  ? DateFormat(
                                      'dd MMM yyyy',
                                    ).format(t.tanggal!)
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
                          fontSize: 13,
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
            );
          }).toList(),
        );
      }),
    ],
  );
}