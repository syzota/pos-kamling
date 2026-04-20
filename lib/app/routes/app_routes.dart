import 'package:get/get.dart';

// AUTH
import '../../modules/auth/login/login_binding.dart';
import '../../modules/auth/login/login_view.dart';

// WARGA
import '../../modules/warga/dashboard/warga_dashboard_binding.dart';
import '../../modules/warga/dashboard/warga_dashboard_view.dart';
import '../../modules/warga/calendar/calendar_binding.dart';
import '../../modules/warga/calendar/calendar_view.dart';
import '../../modules/warga/finance/warga_finance_binding.dart';
import '../../modules/warga/finance/warga_finance_view.dart';
import '../../modules/warga/letter/letter_binding.dart';
import '../../modules/warga/letter/letter_view.dart';
import '../../modules/warga/announcement/announcement_binding.dart';
import '../../modules/warga/announcement/announcement_view.dart';
import '../../modules/warga/notification/warga_notification_binding.dart';
import '../../modules/warga/notification/warga_notification_view.dart';
import '../../modules/warga/profile/warga_profile_binding.dart';
import '../../modules/warga/profile/warga_profile_view.dart';

// ADMIN
import '../../modules/admin/dashboard/admin_dashboard_binding.dart';
import '../../modules/admin/dashboard/admin_dashboard_view.dart';
import '../../modules/admin/residents/residents_binding.dart';
import '../../modules/admin/residents/residents_view.dart';
import '../../modules/admin/letters/admin_letters_binding.dart';
import '../../modules/admin/letters/admin_letters_view.dart';
import '../../modules/admin/finance/admin_finance_binding.dart';
import '../../modules/admin/finance/admin_finance_view.dart';
import '../../modules/admin/activities/activities_binding.dart';
import '../../modules/admin/activities/activities_view.dart';
import '../../modules/admin/profile/admin_profile_binding.dart';
import '../../modules/admin/profile/admin_profile_view.dart';
import '../../modules/admin/announcement/admin_announcement_binding.dart';
import '../../modules/admin/announcement/admin_announcement_view.dart';
import '../../modules/admin/notification/admin_notification_binding.dart';
import '../../modules/admin/notification/admin_notification_view.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';

  // WARGA
  static const String wargaDashboard = '/warga/dashboard';
  static const String wargaCalendar = '/warga/calendar';
  static const String wargaFinance = '/warga/finance';
  static const String wargaLetter = '/warga/letter';
  static const String wargaAnnouncement = '/warga/announcement';
  static const String wargaNotification = '/warga/notification';
  static const String wargaProfile = '/warga/profile';

  // ADMIN
  static const String adminDashboard = '/admin/dashboard';
  static const String adminResidents = '/admin/residents';
  static const String adminResidentsForm = '/admin/residents/form';
  static const String adminResidentsDetail = '/admin/residents/detail';
  static const String adminLetters = '/admin/letters';
  static const String adminFinance = '/admin/finance';
  static const String adminFinanceForm = '/admin/finance/form';
  static const String adminActivities = '/admin/activities';
  static const String adminActivitiesDetail = '/admin/activities/detail';
  static const String adminAnnouncement = '/admin/announcement';
  static const String adminProfile = '/admin/profile';
  static const String adminNotification = '/admin/notification';

  // =========================
  // WARGA BOTTOM NAV (FIXED)
  // =========================
  static void navigateWargaBottomNav(int index) {
    final routes = [
      wargaDashboard, // 0 Home
      wargaLetter, // 1 Surat
      wargaFinance, // 2 Keuangan
      wargaCalendar, // 3 Kalender ✅ FIXED
      wargaAnnouncement, // 4 Pengumuman
    ];

    if (index >= 0 && index < routes.length) {
      Get.offNamed(routes[index]);
    }
  }

  // =========================
  // ADMIN BOTTOM NAV
  // =========================
  static void navigateAdminBottomNav(int index) {
    final routes = [
      adminDashboard,
      adminResidents,
      adminLetters,
      adminFinance,
      adminActivities,
      adminAnnouncement,
    ];

    if (index >= 0 && index < routes.length) {
      Get.offNamed(routes[index]);
    }
  }

  // =========================
  // GET PAGES
  // =========================
  static final List<GetPage> pages = [
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    // WARGA
    GetPage(
      name: wargaDashboard,
      page: () => const WargaDashboardView(),
      binding: WargaDashboardBinding(),
    ),
    GetPage(
      name: wargaCalendar,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: wargaFinance,
      page: () => const WargaFinanceView(),
      binding: WargaFinanceBinding(),
    ),
    GetPage(
      name: wargaLetter,
      page: () => const LetterView(),
      binding: LetterBinding(),
    ),
    GetPage(
      name: wargaAnnouncement,
      page: () => const AnnouncementView(),
      binding: AnnouncementBinding(),
    ),
    GetPage(
      name: wargaNotification,
      page: () => const WargaNotificationView(),
      binding: WargaNotificationBinding(),
    ),
    GetPage(
      name: wargaProfile,
      page: () => const WargaProfileView(),
      binding: WargaProfileBinding(),
    ),

    // ADMIN
    GetPage(
      name: adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: adminResidents,
      page: () => const ResidentsView(),
      binding: ResidentsBinding(),
    ),
    GetPage(
      name: adminLetters,
      page: () => const AdminLettersView(),
      binding: AdminLettersBinding(),
    ),
    GetPage(
      name: adminFinance,
      page: () => const AdminFinanceView(),
      binding: AdminFinanceBinding(),
    ),
    GetPage(
      name: adminActivities,
      page: () => const ActivitiesView(),
      binding: ActivitiesBinding(),
    ),
    GetPage(
      name: adminAnnouncement,
      page: () => const AdminAnnouncementView(),
      binding: AdminAnnouncementBinding(),
    ),
    GetPage(
      name: adminProfile,
      page: () => const AdminProfileView(),
      binding: AdminProfileBinding(),
    ),
    GetPage(
      name: adminNotification,
      page: () => const AdminNotificationView(),
      binding: AdminNotificationBinding(),
    ),
  ];
}
