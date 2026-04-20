import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/providers/storage_provider.dart';
import 'app/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

Future<void> checkLoginStatus() async {
  final storage = StorageProvider();

  String? token = await storage.getToken();
  String? role = await storage.getRole();

  await Future.delayed(Duration.zero); // pastikan context ready

  if (token != null) {
    if (role == 'admin') {
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else {
      Get.offAllNamed(AppRoutes.wargaDashboard);
    }
  } else {
    Get.offAllNamed(AppRoutes.login);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await NotificationService().init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const RTDigitalApp());
}

class RTDigitalApp extends StatelessWidget {
  const RTDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pos Kamling',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
      initialBinding: BindingsBuilder(() {
        checkLoginStatus();
      }),
    );
  }
}
