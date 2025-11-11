import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/friends/controller/friend_controller.dart';
import '../widgets/friend_card.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.put(FriendsController());
  final RxInt currentTabIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        currentTabIndex.value = _tabController.index;
      }
    });

    controller.listenForFriendRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildFriendsTab() {
    return Obx(() {
      final friends = controller.filteredFriends;
      if (friends.isEmpty) {
        return const Center(child: Text("No friends yet."));
      }
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: FriendCard(
              friend: friend,
              onToggleFriend: () => controller.toggleFriendStatus(friend),
            ),
          );
        },
      );
    });
  }

  Widget _buildRequestsTab() {
    return Obx(() {
      final requests = controller.friendRequests;
      if (requests.isEmpty) {
        return const Center(child: Text("No friend requests."));
      }
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: FriendCard(
              friend: req,
             
              onAccept: () => controller.acceptRequest(req.id),
              onReject: () => controller.rejectRequest(req.id),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Text(
                "Friends",
                style: GoogleFonts.inter(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kLightGray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  tabs: const [
                    Tab(text: 'Friends'),
                    Tab(text: 'Requests'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15.h),

            // Search bar only on Friends tab
            Obx(() {
              if (currentTabIndex.value == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 48.h,
                    child: TextField(
                      onChanged: (val) => controller.searchQuery.value = val,
                      decoration: InputDecoration(
                        hintText: 'Search friends...',
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Icon(Icons.search,
                              color: AppColors.whiteColor),
                        ),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.kLightGray,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.kLightGray,
                            width: 1.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),

            SizedBox(height: 15.h),

            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFriendsTab(),
                  _buildRequestsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:whisp/config/constants/colors.dart';
// import 'package:whisp/features/friends/controller/friend_controller.dart';

// import '../widgets/friend_card.dart';

// class FriendsScreen extends StatelessWidget {
//   const FriendsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(FriendsController());

//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
//               child: Text(
//                 "Friends",
//                 style: GoogleFonts.inter(
//                   fontSize: 32.sp,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             SizedBox(height: 15.h),

//             // 🔍 Search Field
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 65),
//               child: SizedBox(
//                 height: 48.h,
//                 child: TextField(
//                   onChanged: (val) => controller.searchQuery.value = val,
//                   decoration: InputDecoration(
//                     hintText: 'Search friends...',
//                     suffixIcon: Container(
//                       margin: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: AppColors.primary,
//                         //borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(
//                         Icons.search,
//                         color: AppColors.whiteColor,
//                       ),
//                     ),
//                     filled: true,
//                     fillColor: AppColors.whiteColor,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: AppColors.kLightGray,
//                         width: 1,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: AppColors.kLightGray,
//                         width: 1.w,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // 👥 Friends List
//             Expanded(
//               child: Obx(() {
//                 final friends = controller.filteredFriends;
//                 return ListView.builder(
//                   itemCount: friends.length,
//                   itemBuilder: (context, index) {
//                     final friend = friends[index];
//                     return FriendCard(
//                       friend: friend,
//                       onToggleFriend: () =>
//                           controller.toggleFriendStatus(friend),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
