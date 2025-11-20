import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/features/auth/view/login_view.dart';

import 'package:whisp/features/profile/controller/preference_controller.dart';

import 'package:whisp/features/home/view/home_screen.dart';

import 'package:whisp/features/profile/controller/profile_controller.dart';
import 'package:whisp/features/profile/view/edit_profile.dart';
import 'package:whisp/features/profile/view/preference_screen.dart';
import 'package:whisp/features/profile/view/prefrence_loader_screen.dart';
import 'package:whisp/features/profile/widgets/preference_selector_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool? _notificationsEnabled; // Null until loaded to prevent animation
  int _switchKey = 0; // Key that only changes on user interaction

  String userName = "User";
  String userEmail = "";
  String? profilePic;

  final controller = Get.put(EditProfileController());
  //final preferencesController = Get.put(PreferenceController());

  @override
  void initState() {
    super.initState();
    _initializeNotificationState();
    _loadUser();
    // preferencesController.loadPreferences();
    ever(controller.user, (updatedUser) {
      if (!mounted) return; // ✅ Prevent setState after dispose
      setState(() {
        userName = updatedUser.name;
        userEmail = updatedUser.email;
        profilePic = updatedUser.profilePic;
      });
    });
  }

  Future<void> _initializeNotificationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool('notificationsEnabled') ?? true;
    // Set value before first build completes to prevent animation
    if (mounted) {
      setState(() {
        _notificationsEnabled = savedValue;
      });
    }
  }

  Future<void> _loadUser() async {
    final user = SessionController().user;
    setState(() {
      userName = user?.name ?? "User";
      profilePic = user?.profilePic;
      userEmail = user?.email ?? 'no email';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainHomeScreen(index: 0)),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== AppBar with Back Button =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        const Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== Profile Picture =====
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          profilePic != null && profilePic!.isNotEmpty
                          ? NetworkImage(profilePic!)
                          : const AssetImage(
                                  'assets/images/place_holder_pic.jpg',
                                )
                                as ImageProvider,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===== User Name =====
              Center(
                child: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ===== User Email =====
              Center(
                child: Text(
                  userEmail,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),

              const SizedBox(height: 32),

              // ===== Settings Section =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== Notifications Toggle =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Notifications",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (_notificationsEnabled ?? true)
                                ? "Receive push notifications"
                                : "Notifications are off",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_notificationsEnabled != null)
                      Switch(
                        key: ValueKey(_switchKey),
                        value: _notificationsEnabled!,
                        onChanged: (value) async {
                          // Only change key on user interaction to prevent animation on load
                          _switchKey++;
                          setState(() {
                            _notificationsEnabled = value;
                          });
                          // TODO: Call API here to update notification settings
                          debugPrint('Notifications: $value');
                          try {
                            final response = await http.put(
                              Uri.parse(
                                '${ApiEndpoints.baseUrl}/api/auth/notifications',
                              ),
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization':
                                    'Bearer ${SessionController().user!.token!}',
                              },
                              body: jsonEncode({'enabled': value}),
                            );

                            if (response.statusCode != 200) {
                              setState(() => _notificationsEnabled = !value);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool(
                                'notificationsEnabled',
                                _notificationsEnabled ?? true,
                              );
                            } else {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool(
                                'notificationsEnabled',
                                _notificationsEnabled ?? true,
                              );
                            }
                          } catch (e) {
                            setState(() => _notificationsEnabled = !value);
                          }
                        },
                        activeThumbColor: Colors.black,
                        activeTrackColor: Colors.grey.shade300,
                      )
                    else
                      SizedBox(
                        width: 48,
                        height: 24,
                        child: Switch(
                          value: true,
                          onChanged: null, // Disabled until loaded
                          activeThumbColor: Colors.black,
                          activeTrackColor: Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomButton(
                  text: 'Set Preferences',
                  onPressed: () {
                     
                    if (SessionController().user?.premium == true) {
                     Get.to(() => PreferenceLoaderScreen());
                    
                

                    } else {
                      Get.defaultDialog(
                        title: "Premium Feature",
                        middleText: "Buy premium to use this feature",
                        confirm: ElevatedButton(
                          onPressed: () => Get.back(),
                          child: const Text("OK"),
                        ),
                      );
                    }
                  },
                ),
              ),
             
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                  text: 'Edit Profile',
                  onPressed: () {
                    Get.to(EditProfileScreen());
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: CustomButton(
                  text: 'Logout',
                  onPressed: () {
                    // Clear session and user data
                    SessionController().clearSession();

                    // Navigate to login screen and remove all previous routes
                    Get.offAll(() => LoginView());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
