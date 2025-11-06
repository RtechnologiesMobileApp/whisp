import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/utils/manager/shared_preferences/shared_preferences_manager.dart';
import 'package:whisp/utils/manager/user_prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final manager = SharedPreferencesManager.instance;
  String userName = "";
  String? userImage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await manager.getUser();
    setState(() {
      userName = user?.name ?? "User";
      userImage = user?.profilePic; // assuming your model has this
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: Logo (left) and Avatar (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logo, height: 70, fit: BoxFit.contain),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.login);
                    },
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          (userImage != null && userImage!.isNotEmpty)
                          ? NetworkImage(userImage!)
                          : const AssetImage(AppImages.placeholderpic)
                                as ImageProvider,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Welcome text + username below the top bar
              Text(
                "Welcome",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 270.w, // optional: responsive max width
                    maxHeight: 400.h, // optional: responsive max height
                  ),
                  child: Image.asset(
                    AppImages.startChating,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const Spacer(),

              // 💜 Start Chatting Button
              CustomButton(
                text: "Start Chatting",
                onPressed: () {
                  Get.toNamed("/chat");
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
