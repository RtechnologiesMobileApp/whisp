import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisp/config/bindings/app_bindings.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/features/auth/controllers/login_controller.dart';
import 'package:whisp/features/onboarding/view/screen/spalsh_screen.dart';
import 'package:whisp/firebase_options.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before runApp
 

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812), // base design size (iPhone X for example)
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
        initialBinding: AppBindings(), 
      initialRoute: Routes.dob, 
      getPages: AppPages.routes, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}
