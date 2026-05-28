
import 'package:get/get.dart';

import 'app_routes.dart';

import '../../modules/auth/login/login_binding.dart';
import '../../modules/auth/login/login_view.dart';
import '../../modules/splash/splash_screen.dart';

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
import '../../modules/admin/announcement/admin_announcement_binding.dart';
import '../../modules/admin/announcement/admin_announcement_view.dart';
import '../../modules/admin/notification/admin_notification_binding.dart';
import '../../modules/admin/notification/admin_notification_view.dart';

import '../../modules/profile/profile_binding.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/profile/edit_profile/edit_profile_binding.dart';
import '../../modules/profile/edit_profile/edit_profile_view.dart';
import '../../modules/profile/security/security_binding.dart';
import '../../modules/profile/security/security_view.dart';

abstract class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static const _defaultTransition = Transition.fadeIn;
  static const _detailTransition = Transition.rightToLeftWithFade;
  static const _modalTransition = Transition.downToUp;
  static const _duration = Duration(milliseconds: 280);

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),

    GetPage(
      name: AppRoutes.wargaDashboard,
      page: () => const WargaDashboardView(),
      binding: WargaDashboardBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.wargaCalendar,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.wargaFinance,
      page: () => const WargaFinanceView(),
      binding: WargaFinanceBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.wargaLetter,
      page: () => const LetterView(),
      binding: LetterBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.wargaAnnouncement,
      page: () => const AnnouncementView(),
      binding: AnnouncementBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.wargaNotification,
      page: () => const WargaNotificationView(),
      binding: WargaNotificationBinding(),
      transition: _detailTransition,
      transitionDuration: _duration,
    ),

    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminResidents,
      page: () => const ResidentsView(),
      binding: ResidentsBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminResidentsForm,
      page: () => const ResidentFormView(),
      binding: ResidentsBinding(),
      transition: _detailTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminResidentsDetail,
      page: () => const ResidentDetailView(),
      binding: ResidentsBinding(),
      transition: _detailTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminLetters,
      page: () => const AdminLettersView(),
      binding: AdminLettersBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminFinance,
      page: () => const AdminFinanceView(),
      binding: AdminFinanceBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminFinanceForm,
      page: () => const AdminFinanceFormView(),
      binding: AdminFinanceBinding(),
      transition: _modalTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminActivities,
      page: () => const ActivitiesView(),
      binding: ActivitiesBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminActivitiesDetail,
      page: () => const ActivityDetailView(),
      binding: ActivitiesBinding(),
      transition: _detailTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminAnnouncement,
      page: () => const AdminAnnouncementView(),
      binding: AdminAnnouncementBinding(),
      transition: _defaultTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.adminNotification,
      page: () => const AdminNotificationView(),
      binding: AdminNotificationBinding(),
      transition: _detailTransition,
      transitionDuration: _duration,
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: _detailTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
      transition: _detailTransition,
      transitionDuration: _duration,
    ),
    GetPage(
      name: AppRoutes.security,
      page: () => const SecurityView(),
      binding: SecurityBinding(),
      transition: _detailTransition,
      transitionDuration: _duration,
    ),
  ];
}
