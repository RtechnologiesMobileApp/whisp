import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/services/session_manager.dart';

class GenderController extends GetxController {
  var selectedGender = (-1).obs;
  final Dio dio = Dio();
  final isLoading = false.obs;

  void selectGender(int index) {
    selectedGender.value = index;
  }

  Future<void> continueNext() async {
    if (selectedGender.value == -1) {
      Get.snackbar("Select Gender", "Please select your gender to continue");
      return;
    }

    // 👇 Convert index to string value based on your backend
    String genderString;
    switch (selectedGender.value) {
      case 0:
        genderString = "female";
        break;
      case 1:
        genderString = "male";
        break;
      default:
        genderString = "not_specified";
    }

    try {
      isLoading.value = true;
      final token = SessionController().user?.token;

      final response = await dio.put(
        ApiEndpoints.updateProfile,
        data: {"gender": genderString},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print(":white_tick: Gender updated: ${response.data}");
      Get.snackbar("Success", "Gender updated successfully");

      // 👇 navigate to DOB screen next
      Get.toNamed(Routes.dob);
    } catch (e) {
      print(":x: Gender update failed: $e");
      Get.snackbar("Error", "Failed to update gender: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
