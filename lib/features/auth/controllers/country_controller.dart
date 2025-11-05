import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/shared_preferences/shared_preferences_constants.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/utils/manager/shared_preferences/shared_preferences_manager.dart';
import 'package:whisp/utils/manager/user_prefs.dart';
import 'package:whisp/features/auth/models/user_model.dart';

class CountryController extends GetxController {
  final Dio dio = Dio();
  final manager = SharedPreferencesManager.instance;
  final constants = SharedPreferencesConstants.instance;

  var selectedCountry = ''.obs;
  var isLoading = false.obs;

  /// Method to set selected country
  void selectCountry(String countryName) {
    selectedCountry.value = countryName;
  }

  /// API call to update country
  Future<void> updateCountry() async {
    if (selectedCountry.value.isEmpty) {
      Get.snackbar("Select Country", "Please select your country to continue");
      return;
    }

    try {
      isLoading.value = true;

      final token = await manager.getString(key: constants.userTokenConstant);

      final response = await dio.put(
        ApiEndpoints.updateProfile,
        data: {"country": selectedCountry.value},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("✅ Country updated: ${response.data}");
      Get.snackbar("Success", "Country updated successfully");

      // Save updated user locally
      final Map<String, dynamic>? userJson =
          (response.data is Map) ? response.data['user'] as Map<String, dynamic>? : null;
      if (userJson != null) {
        await manager.saveUser(UserModel.fromJson(userJson));
      }

      // ✅ Navigate to Welcome screen
      Get.offAllNamed(Routes.welcomehome);
    } catch (e) {
      print("❌ Country update failed: $e");
      Get.snackbar("Error", "Failed to update country: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
