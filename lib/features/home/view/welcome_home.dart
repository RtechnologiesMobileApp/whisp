import 'package:flutter/material.dart';
import 'package:whisp/features/home/widgets/home_header.dart';
import 'package:whisp/features/home/widgets/start_button.dart';
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
      userImage = user?.profilePic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HomeHeader(userName: userName, userImage: userImage??''),
              StartButton(),
              SizedBox(),
              SizedBox(),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
