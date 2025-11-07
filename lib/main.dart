import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisp/config/bindings/app_bindings.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/config/theme/theme.dart';
import 'package:whisp/features/onboarding/view/screen/splash_screen.dart';
import 'package:whisp/firebase_options.dart';
import 'package:whisp/core/services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await AdService().init();
  await AdService().loadInterstitialAd();

  // Initialize Firebase before runApp
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ScreenUtilInit(
      designSize: const Size(
        375,
        812,
      ), // base design size (iPhone X for example)
      minTextAdapt: true,
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Whisp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AppBindings(),
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
      home: SplashScreen(),
    );
  }
}
