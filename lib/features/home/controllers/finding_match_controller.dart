import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:whisp/core/services/ad_service.dart';
import 'package:whisp/core/services/session_manager.dart';
import '../../../core/services/socket_service.dart';
import 'package:whisp/config/routes/app_pages.dart';
 



class FindingMatchController extends GetxController {
  final SocketService socketService = SocketService.to;
  final box = GetStorage();


  final isSearching = false.obs;
  final partnerId = RxnString();
  final hasMatched = false.obs;
  final isPremium = false.obs;
  // track how many chats done
  int chatCount = 0;

  // init: connect already done at app start or do it here
  @override
  void onInit() {
    super.onInit();
      final user = SessionController().user;
  if (user != null) {
    isPremium.value = user.premium; // default to false if null
  }

     final storedCount = box.read('chatCount');
  chatCount = (storedCount is int) ? storedCount : 0;

    // Listen server events:
    socketService.onAuthOk((data) {
      debugPrint('AUTH_OK: $data');
    });

    socketService.onMatchFound((data) async {
      // server sends { partnerId, partnerName, partnerAvatar }
      log("this is on match found data: ${data.toString()}");
      final id = data['partner']['id'] as String?;
      final name = data['partner']['fullName'] as String?;
      final avatar = data['partner']['avatar'] as String?;

      debugPrint('MATCH_FOUND with $id, name: $name, avatar: $avatar');

      if (id != null) {
        partnerId.value = id;
        hasMatched.value = true;
          if (isPremium.value) {
          chatCount++;
          box.write('chatCount', chatCount);

          // show ad only every 4th chat
          if (chatCount % 4 == 0) {
            AdService().showInterstitialAd();
          }
        } else {
          // normal user => show every time
          AdService().showInterstitialAd();
        }

        //AdService().showInterstitialAd();

        await Future.delayed(const Duration(seconds: 1));

        // navigate to chat screen with all details
        Get.offNamed(
          Routes.chatscreen,
          arguments: {
            'partnerId': id,
            'partnerName': name ?? 'Unknown',
            'partnerAvatar': avatar ?? '',
          },
        );
      }
    });

    socketService.onError((data) {
      debugPrint('Socket error: $data');
      // optionally show toast
    });

    socketService.onPartnerLeft(() {
      final navigatorState = Get.key.currentState;
      final canPop = navigatorState?.canPop() ?? false;
      final currentRoute = Get.currentRoute;

      if (Get.isOverlaysOpen) {
        Get.back();
      }

      if (currentRoute == Routes.chatscreen) {
        if (canPop) {
          Get.until(
            (route) =>
                (route.settings.name != null &&
                    route.settings.name == Routes.welcomehome) ||
                route.isFirst,
          );
        }
      } else if (canPop) {
        Get.back();
      }

      Get.snackbar(
        'Partner Disconnected',
        'Your chat partner has left the chat.',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Partner left');
      // if you are on the chat screen you might show a dialog and go home
    });
  }

  // Called when entering FindingMatchScreen UI
  void startSearch() {
    if (!socketService.connected) {
      // optionally connect again or show error
      debugPrint('Socket not connected');
      // you could attempt to re-init socket here
      return;
    }
    AdService().loadInterstitialAd();
    isSearching.value = true;
    socketService.readyForRandom();
  }

  // Called when cancel button tapped
  void cancelSearch() {
    debugPrint("🛑 Cancel search tapped");

    if (isSearching.value) {
      socketService.cancelRandom();
      isSearching.value = false;
    }

    // Always go back to previous screen
    if (Get.isOverlaysOpen) {
      Get.back(); // Close dialog/sheet first if open
    } else {
      Get.back(); // Normal back navigation
    }
  }

  @override
  void onClose() {
    // If user leaves the screen without pressing cancel explicitly
    if (isSearching.value && !hasMatched.value) {
      socketService.cancelRandom();
      isSearching.value = false;
    }
    super.onClose();
  }
}
