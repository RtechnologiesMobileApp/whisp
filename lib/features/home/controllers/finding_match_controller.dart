import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../services/socket_service.dart';
import 'package:whisp/config/routes/app_pages.dart';

class FindingMatchController extends GetxController {
  final SocketService socketService = SocketService.to;

  final isSearching = false.obs;
  final partnerId = RxnString();

  // init: connect already done at app start or do it here
  @override
  void onInit() {
    super.onInit();

    // Listen server events:
    socketService.onAuthOk((data) {
      print('AUTH_OK: $data');
    });

  socketService.onMatchFound((data) {
  // server sends { partnerId, partnerName, partnerAvatar }
  final id = data['partnerId'] as String?;
  final name = data['partnerName'] as String?;
  final avatar = data['partnerAvatar'] as String?;

  print('MATCH_FOUND with $id, name: $name, avatar: $avatar');

  if (id != null) {
    partnerId.value = id;

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
      print('Socket error: $data');
      // optionally show toast
    });

    socketService.onPartnerLeft(() {
      print('Partner left');
      // if you are on the chat screen you might show a dialog and go home
    });
  }

  // Called when entering FindingMatchScreen UI
  void startSearch() {
    if (!socketService.connected) {
      // optionally connect again or show error
      print('Socket not connected');
      // you could attempt to re-init socket here
      return;
    }
    isSearching.value = true;
    socketService.readyForRandom();
  }

  // Called when cancel button tapped
  void cancelSearch() {
    if (!isSearching.value) return;
    socketService.cancelRandom();
    isSearching.value = false;
    // go back
    Get.back();
  }

  @override
  void onClose() {
    // If user leaves the screen without pressing cancel explicitly
    if (isSearching.value) {
      socketService.cancelRandom();
      isSearching.value = false;
    }
    super.onClose();
  }
}
