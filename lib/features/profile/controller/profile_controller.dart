import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisp/core/services/session_manager.dart';
import 'package:whisp/features/profile/repo/edit_prof_repo.dart';

class EditProfileController extends GetxController {
  final EditProfRepo _repo = EditProfRepo();

  var isLoading = false.obs;
  var user = SessionController().user!.obs;
  File? avatarFile;
  var selectedImage = Rx<File?>(null);
  var selectedCountry = ''.obs;

  void loadUser() {
    final sessionUser = SessionController().user;
    if (sessionUser != null) {
      user.value = sessionUser;
      selectedCountry.value = sessionUser.country ?? '';
      selectedImage.value = null; // Reset image selection
    }
  }

  /// Update profile - only sends changed fields
  Future<void> updateProfile({
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? country,
  }) async {
    try {
      isLoading.value = true;
      // Only send changed values
      final updatedUser = await _repo.updateProfile(
        fullName: fullName != user.value.name ? fullName : null,
        dateOfBirth: dateOfBirth != user.value.dob ? dateOfBirth : null,
        gender: gender != user.value.gender ? gender : null,
        country: country != user.value.country ? country : null,
        avatar: selectedImage.value, // send only if changed
      );
      // Update local session
      user.value = updatedUser;
      selectedImage.value = null; // reset after upload
      Get.snackbar("Success", "Profile updated successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick avatar from gallery
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }
}
