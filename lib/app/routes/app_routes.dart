
import 'package:get/get.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';

  static const wargaDashboard = '/warga/dashboard';
  static const wargaCalendar = '/warga/calendar';
  static const wargaFinance = '/warga/finance';
  static const wargaLetter = '/warga/letter';
  static const wargaAnnouncement = '/warga/announcement';
  static const wargaNotification = '/warga/notification';

  static const adminDashboard = '/admin/dashboard';
  static const adminResidents = '/admin/residents';
  static const adminResidentsForm = '/admin/residents/form';
  static const adminResidentsDetail = '/admin/residents/detail';
  static const adminLetters = '/admin/letters';
  static const adminFinance = '/admin/finance';
  static const adminFinanceForm = '/admin/finance/form';
  static const adminActivities = '/admin/activities';
  static const adminActivitiesDetail = '/admin/activities/detail';
  static const adminAnnouncement = '/admin/announcement';
  static const adminNotification = '/admin/notification';

  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const security = '/profile/security';
  static const notificationSettings = '/profile/notifications';

  static const wargaProfile = profile;
  static const adminProfile = profile;

  static const List<String> wargaTabs = [
    wargaDashboard,
    wargaLetter,
    wargaFinance, 
    wargaCalendar,
    wargaAnnouncement,
  ];

  static const List<String> adminTabs = [
    adminDashboard,
    adminResidents,
    adminLetters,
    adminFinance,
    adminActivities,
    adminAnnouncement,
  ];

  static void navigateWargaBottomNav(int index) {
    if (index < 0 || index >= wargaTabs.length) return;
    final target = wargaTabs[index];
    if (Get.currentRoute == target) return;
    Get.offNamed(target);
  }

  static void navigateAdminBottomNav(int index) {
    if (index < 0 || index >= adminTabs.length) return;
    final target = adminTabs[index];
    if (Get.currentRoute == target) return;
    Get.offNamed(target);
  }

  static int currentBottomNavIndex({required bool isAdmin}) {
    final tabs = isAdmin ? adminTabs : wargaTabs;
    final idx = tabs.indexOf(Get.currentRoute);
    return idx < 0 ? 0 : idx;
  }
}