import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:intl/intl.dart';
import 'package:whisp/config/constants/shared_preferences/shared_preferences_constants.dart';
import 'package:whisp/config/routes/app_pages.dart';
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/utils/manager/shared_preferences/shared_preferences_manager.dart';
import 'package:whisp/utils/manager/user_prefs.dart';
import 'package:whisp/features/auth/models/user_model.dart';

class DobController extends GetxController {
  var selectedDate = DateTime(2000, 1, 1).obs;
  var isLoading = false.obs;

  final Dio dio = Dio();
  final manager = SharedPreferencesManager.instance;
  final constants = SharedPreferencesConstants.instance;

  Future<void> saveDateOfBirth() async {
    try {
      isLoading.value = true;

      // Check if user is at least 13 years old
      final now = DateTime.now();
      final age = now.year - selectedDate.value.year;
      final monthDifference = now.month - selectedDate.value.month;
      final dayDifference = now.day - selectedDate.value.day;
      
      final actualAge = (monthDifference < 0 || (monthDifference == 0 && dayDifference < 0))
          ? age - 1
          : age;

      if (actualAge < 13) {
        isLoading.value = false;
        Get.snackbar(
          "Age Requirement",
          "You must be at least 13 years old to continue. Please select a different date.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final token = await manager.getString(key: constants.userTokenConstant);

      // ✅ Correct FormData creation
      final formData = FormData.fromMap({
        "dateOfBirth": formattedDate,
      });

      final response = await dio.put(
        ApiEndpoints.updateProfile,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      print("✅ DOB updated: ${response.data}");
      Get.snackbar("Success", "Date of Birth updated successfully");

print('Navigating to: ${Routes.country}');
 
      // Save updated user locally
      final Map<String, dynamic>? userJson =
          (response.data is Map) ? response.data['user'] as Map<String, dynamic>? : null;
      if (userJson != null) {
        await manager.saveUser(UserModel.fromJson(userJson));
      }

      Get.toNamed(Routes.country);
    } on DioException catch (e) {
      print("❌ Dio error: ${e.response?.data ?? e.message}");
      Get.snackbar("Error", "Server error: ${e.response?.statusCode ?? e.message}");
    } catch (e) {
      print("❌ Unexpected error: $e");
      Get.snackbar("Error", "Failed to update Date of Birth");
    } finally {
      isLoading.value = false;
    }
  }
}
