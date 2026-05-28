import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isAdmin;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.isAdmin,
    required this.onTap,
  });

  static const _wargaItems = <_NavItem>[
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Beranda'),
    _NavItem(icon: Icons.description_outlined, activeIcon: Icons.description_rounded, label: 'Surat'),
    _NavItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet_rounded, label: 'Kas'),
    _NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Kalender'),
    _NavItem(icon: Icons.campaign_outlined, activeIcon: Icons.campaign_rounded, label: 'Pengumuman'),
  ];

  static const _adminItems = <_NavItem>[
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.people_outline_rounded, activeIcon: Icons.people_rounded, label: 'Warga'),
    _NavItem(icon: Icons.description_outlined, activeIcon: Icons.description_rounded, label: 'Surat'),
    _NavItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet_rounded, label: 'Kas'),
    _NavItem(icon: Icons.event_note_outlined, activeIcon: Icons.event_note_rounded, label: 'Kegiatan'),
    _NavItem(icon: Icons.campaign_outlined, activeIcon: Icons.campaign_rounded, label: 'Pengumuman'),
  ];

  @override
  Widget build(BuildContext context) {
    final items = isAdmin ? _adminItems : _wargaItems;
    final safeIndex =
        (currentIndex >= 0 && currentIndex < items.length) ? currentIndex : 0;

    final navHeight = isAdmin ? 68.0 : 64.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.4),
            width: 0.6,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: navHeight,
          child: Row(
            children: List.generate(items.length, (i) {
              return _BottomNavTile(
                item: items[i],
                isActive: i == safeIndex,
                onTap: () => onTap(i),
                isAdmin: isAdmin,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _BottomNavTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final bool isAdmin;
  final VoidCallback onTap;

  const _BottomNavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isAdmin ? 20.0 : 22.0;
    final fontSize = isAdmin ? 9.0 : 11.0;
    final iconPadH = isAdmin ? 8.0 : 14.0;
    final iconPadV = isAdmin ? 3.0 : 4.0;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: iconPadH,
                    vertical: iconPadV,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withOpacity(0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    isActive ? item.activeIcon : item.icon,
                    size: iconSize,
                    color: isActive ? AppColors.primary : AppColors.outline,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: fontSize,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.primary : AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}