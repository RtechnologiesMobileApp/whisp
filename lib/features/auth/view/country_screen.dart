import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whisp/core/widgets/custom_back_button.dart';
import 'package:whisp/features/auth/controllers/signup_controller.dart';


class CountryScreen extends StatelessWidget {
  const CountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Scaffold(
      appBar: AppBar(leading: CustomBackButton()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Please enter your Country",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Search bar
            GestureDetector(
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: false,
                  countryListTheme: CountryListThemeData(
                    bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
                    borderRadius: BorderRadius.zero,
                    inputDecoration: InputDecoration(
                      labelText: 'Search Country',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.purple,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onSelect: (Country country) {
                    controller.selectedCountry.value =
                        "${country.flagEmoji} ${country.name}";
                  },
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        controller.selectedCountry.value.isEmpty
                            ? "Search Country"
                            : controller.selectedCountry.value,
                        style: TextStyle(
                          color: controller.selectedCountry.value.isEmpty
                              ? Colors.grey
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Continue button
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.updateCountry(),
                child: Text(
                  controller.isLoading.value ? "Saving..." : "Continue",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
