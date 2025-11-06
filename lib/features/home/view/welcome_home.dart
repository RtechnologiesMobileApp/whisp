import 'package:flutter/material.dart';
import 'package:whisp/features/home/widgets/home_header.dart';
import 'package:whisp/features/home/widgets/start_button.dart';
import 'package:whisp/core/services/session_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  String? userImage;
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = SessionController().user;
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
