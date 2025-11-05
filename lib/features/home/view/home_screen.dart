import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/core/widgets/custom_navbar.dart';
import 'package:whisp/features/Chats/view/chat_list_screen.dart';
import 'package:whisp/features/friends/view/screen/friend_screen.dart';
import 'package:whisp/features/premium/view/screens/premium_screen.dart';

class MainHomeScreen extends StatelessWidget {
  final RxInt _selectedIndex = 0.obs;

  final List<Widget> _screens = [
    ChatListScreen(),
    FriendsScreen(),
    PremiumScreen(),
  ];

  MainHomeScreen({super.key});

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[_selectedIndex.value]),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
