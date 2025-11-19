import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:whisp/config/constants/colors.dart';
 
import '../controller/preference_controller.dart';

class PreferenceSelectorWidget extends StatelessWidget {
  final PreferenceController controller;

  const PreferenceSelectorWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      child: Column(
        
            children: [
              SingleChildScrollView(
                // padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                IconButton(onPressed:(){
                  Get.back();
                } , icon: Icon(Icons.close))
              ]),
                  // ---------------- GENDER ----------------
                _buildCheckboxTile(
        title: "Gender",
        checked: controller.genderEnabled,
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      
      child: Obx(() => Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              _buildGenderOption("Male"),
              _buildGenderOption("Female"),
              _buildGenderOption("Other"),
            ],
          )),
        ),
      ),
      
                  // ---------------- AGE RANGE ----------------
                  _buildCheckboxTile(
                    title: "Age Range",
                    checked: controller.ageEnabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.ageRange.value.start.round()} - ${controller.ageRange.value.end.round()} years",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        RangeSlider(
                          values: controller.ageRange.value,
                          min: 18,
                          max: 70,
                          divisions: 52,
                          labels: RangeLabels(
                            controller.ageRange.value.start.round().toString(),
                            controller.ageRange.value.end.round().toString(),
                          ),
                          onChanged: (values) {
                            controller.ageRange.value = values;
                          },
                        ),
                      ],
                    ),
                  ),
              
                  // ---------------- COUNTRY & CITY ----------------
                  _buildCheckboxTile(
                    title: "Country & City",
                    checked: controller.countryEnabled,
                    child: Column(
                      children: [
                        CSCPickerPlus(
                          showStates: true, // optional
                          showCities: true,
                          currentCountry: controller.country.value.isEmpty
                              ? null
                              : controller.country.value,
                          currentCity: controller.city.value.isEmpty
                              ? null
                              : controller.city.value,
                        currentState: controller.state.value.isEmpty
      ? null
      : controller.state.value,
      
                          onCountryChanged: (value) {
                            controller.country.value = value ;
                          },
                          onStateChanged: (value) {
                            controller.state.value = value ?? "";
                            log(value??"NO state");
                            log(controller.state.value);
                          },
                          onCityChanged: (value) {
                            controller.city.value = value ?? "";
                            log(value??"NO city");
                            log(controller.city.value);
                          },
                        ),
                      ],
                    ),
                  ),
              
               
                ],
                  )
              ),
      
              // ---------------- SUBMIT BUTTON ----------------
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                     debugPrint("Submit button clicked");
                   await controller.submitPreferences();
                 
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                 child: controller.isLoading.value
    ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
    : const Text(
        "Save Preferences",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),

                ),
              )
            ],
          ),
    ));
  }

Widget _buildGenderOption(String value) {
  return RadioListTile<String>(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(value),
        value: value,
        groupValue: controller.gender.value,
        onChanged: (val) => controller.gender.value = val ?? "",
      );
}

  Widget _buildCheckboxTile({
    required String title,
    required RxBool checked,
    required Widget child,
  }) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: checked.value,
                  onChanged: (v) => checked.value = v ?? false,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ],
            ),

            if (checked.value)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8, bottom: 20),
                child: child,
              ),
          ],
        ));
  }
}
