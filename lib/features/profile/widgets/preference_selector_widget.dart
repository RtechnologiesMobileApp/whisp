import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
 
import '../controller/preference_controller.dart';

class PreferenceSelectorWidget extends StatelessWidget {
  final PreferenceController controller;

  const PreferenceSelectorWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                  // ---------------- GENDER ----------------
                  _buildCheckboxTile(
                    title: "Gender",
                    checked: controller.genderEnabled,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: controller.gender.value.isEmpty
                            ? null
                            : controller.gender.value,
                        hint: const Text("Select Gender"),
                        items: ["Male", "Female", "Other"]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            controller.gender.value = value ?? "",
                      ),
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
                          onCountryChanged: (value) {
                            controller.country.value = value ?? "";
                          },
                          onStateChanged: (value) {
                            controller.state.value = value ?? "";
                          },
                          onCityChanged: (value) {
                            controller.city.value = value ?? "";
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
    )
              ),
            ),

            // ---------------- SUBMIT BUTTON ----------------
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   debugPrint("Submit button clicked");
                  controller.submitPreferences();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Preferences",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ));
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
