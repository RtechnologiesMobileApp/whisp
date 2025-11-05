import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisp/features/auth/repo/auth_repo.dart';
 

class ProfileController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final isLoading = false.obs;

  final AuthRepository _authRepo = Get.find<AuthRepository>();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) {
      selectedImage.value = File(picked.path);
    } else {
      Get.snackbar("No Image", "Please select an image.");
    }
  }

  Future<void> uploadProfilePic(String userId) async {
    if (selectedImage.value == null) {
      Get.snackbar("Error", "No image selected");
      return;
    }

    try {
      isLoading.value = true;
      final updatedUser = await _authRepo.updateProfilePicture(
        userId: userId,
        imageFile: selectedImage.value!,
      );

      Get.snackbar("Success", "Profile updated successfully!");
      print("Updated User: ${updatedUser.toJson()}");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
