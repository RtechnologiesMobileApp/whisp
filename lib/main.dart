import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Whisp',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.signup, // 👈 starting route
      getPages: AppPages.routes, // 👈 routes with bindings
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
