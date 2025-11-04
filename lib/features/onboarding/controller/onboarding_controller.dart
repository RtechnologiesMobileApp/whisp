import 'package:get/get.dart';
import 'package:whisp/config/constants/images.dart';

class OnboardingController extends GetxController {
  RxInt currentPage = 0.obs;
  final List<Map<String, String>> onBoardingData = [
    {
      'image': AppImages.onBoarding1,
      'title': 'Meet New People, Instantly',
      'subtitle':
          '“Jump into fun conversations with someone new \nevery time. No waiting, no swiping — just start chatting!”',
    },
    {
      'image': AppImages.onBoarding2,
      'title': 'Your Safety Comes First',
      'subtitle':
          '“Chat anonymously. Block or report instantly. Your \nprivacy and comfort are always protected.”',
    },
    {
      'image': AppImages.onBoarding3,
      'title': 'Unlock Premium Features',
      'subtitle':
          '“Reconnect with friends, customize your theme, \nand enjoy ad-free chatting with Whisp Premium.”',
    },
  ];
}
