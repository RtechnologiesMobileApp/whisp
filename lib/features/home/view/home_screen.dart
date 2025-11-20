import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/widgets/custom_navbar.dart';
import 'package:whisp/features/Chats/view/chat_list_screen.dart';
import 'package:whisp/features/friends/view/screen/friend_screen.dart';
import 'package:whisp/features/home/view/welcome_home.dart';
import 'package:whisp/features/premium/view/screens/premium_screen.dart';
import 'package:whisp/features/profile/view/profile_screen.dart';
 

class MainHomeScreen extends StatefulWidget {
 int index;
  MainHomeScreen({super.key, this.index = 0});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final RxInt _selectedIndex = 0.obs;

  final List<Widget> _screens = [
    HomeScreen(),
    ChatListScreen(),
    FriendsScreen(),
    PremiumScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    log('Tapped index: $index');
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex.value = widget.index;
    return Scaffold(
      body: Obx(() => _screens[_selectedIndex.value]),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
