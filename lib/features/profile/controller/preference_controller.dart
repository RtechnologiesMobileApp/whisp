import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:whisp/core/network/api_client.dart';
import 'package:whisp/core/network/api_endpoints.dart';
 

class PreferenceController extends GetxController {
  // Checkbox states
  RxBool genderEnabled = false.obs;
  RxBool ageEnabled = false.obs;
  RxBool countryEnabled = false.obs;
  RxBool cityEnabled = false.obs;

  // Selected values
  RxString gender = "".obs;
  Rx<RangeValues> ageRange = RangeValues(18, 30).obs;
  RxString country = "".obs;
  RxString city = "".obs;
  RxString state = "".obs; // optional, for CSC picker

  final ApiClient _api = ApiClient();

  // API-ready payload
  Map<String, dynamic> get payload {
    // Age as "min-max" string
    String? ageStr;
    if (ageEnabled.value) {
      ageStr =
          "${ageRange.value.start.round()}-${ageRange.value.end.round()}";
    }

    return {
      "matchingPreferences": {
        "gender": genderEnabled.value ? gender.value : null,
        "age": ageStr,
        "country": countryEnabled.value ? country.value : null,
        "city": cityEnabled.value ? city.value : null,
      }
    };
  }

  // ------------------ GET Preferences ------------------
  Future<void> loadPreferences() async {
    try {
      final res = await _api.get(ApiEndpoints.setPreferences, requireAuth: true);
      final data = res["Preferences"] ?? {};

      // Gender
      if (data["gender"] != null) {
        gender.value = data["gender"];
        genderEnabled.value = true;
      } else {
        genderEnabled.value = false;
      }

      // Age
      if (data["age"] != null && data["age"].toString().contains("-")) {
        final parts = data["age"].toString().split("-");
        ageRange.value = RangeValues(
          double.parse(parts[0]),
          double.parse(parts[1]),
        );
        ageEnabled.value = true;
      } else {
        ageEnabled.value = false;
      }

      // Country
      if (data["country"] != null) {
        country.value = data["country"];
        countryEnabled.value = true;
      } else {
        countryEnabled.value = false;
      }

      // City
      if (data["city"] != null) {
        city.value = data["city"];
        cityEnabled.value = true;
      } else {
        cityEnabled.value = false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load preferences");
    }
  }

  // ------------------ PUT Preferences ------------------
 Future<void> submitPreferences() async {
  try {
    debugPrint("Submitting Preferences Payload: ${payload}");

    final res = await _api.put(
      ApiEndpoints.setPreferences,
      data: payload,
      requireAuth: true,
    );

    debugPrint("Response Status: ${res.statusCode}");
    debugPrint("Response Data: ${res.data}");

    if (res.statusCode == 200 || res.statusCode == 201) {
      Get.snackbar("Success", res.data["message"] ?? "Preferences updated");
    } else {
      Get.snackbar("Error", "Failed to save preferences");
    }
  } catch (e) {
    debugPrint("Error saving preferences: $e");
    Get.snackbar("Error", "Failed to save preferences");
  }
}

}

// import 'package:get/get.dart';
// import 'package:flutter/material.dart';

// class PreferenceController extends GetxController {
//   // Checkbox states
//   RxBool genderEnabled = false.obs;
//   RxBool ageEnabled = false.obs;
//   RxBool countryEnabled = false.obs;
//   RxBool cityEnabled = false.obs;

//   // Selected values
//   RxString gender = "".obs;
//   Rx<RangeValues> ageRange = RangeValues(18, 30).obs;
//   RxString country = "".obs;
//   RxString city = "".obs;
 
  
//   // For CSC Picker
//   RxString state = "".obs; // Optional, if needed

//   // API-ready payload
//   Map<String, dynamic> get payload {
//     return {
//       "gender": genderEnabled.value ? gender.value : null,
//       "age_min": ageEnabled.value ? ageRange.value.start.round() : null,
//       "age_max": ageEnabled.value ? ageRange.value.end.round() : null,
//       "country": countryEnabled.value ? country.value : null,
//       "city": cityEnabled.value ? city.value : null,
//     };
//   }

//   // Submit preferences (future PUT API)
//   void submitPreferences() {
//     print("Submitting Preferences:");
//     print(payload);

//     Get.snackbar("Saved", "Preferences updated successfully");
//   }

//   // Load saved preferences (future GET API)
//   void loadSavedPreferences(Map<String, dynamic> data) {
//     gender.value = data["gender"] ?? "";
//     country.value = data["country"] ?? "";
//     city.value = data["city"] ?? "";

//     if (data["age_min"] != null) {
//       ageRange.value = RangeValues(
//         double.parse(data["age_min"].toString()),
//         double.parse(data["age_max"].toString()),
//       );
//     }

//     genderEnabled.value = data["gender"] != null;
//     ageEnabled.value = data["age_min"] != null;
//     countryEnabled.value = data["country"] != null;
//     cityEnabled.value = data["city"] != null;
//   }
// }
 