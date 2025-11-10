
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                showCountryPickerWithIndex(context, controller);
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

  void showCountryPickerWithIndex(
      BuildContext context, SignupController controller) {
    final ScrollController scrollController = ScrollController();
    final TextEditingController searchController = TextEditingController();
    final ValueNotifier<List<Country>> filteredCountries = ValueNotifier([]);
    final List<Country> allCountries = CountryService().getAll();

    filteredCountries.value = allCountries;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              // Header with title and close button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Country',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Country',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.purple,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    filteredCountries.value = allCountries
                        .where((country) => country.name
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Country list with alphabetical index
              Expanded(
                child: Stack(
                  children: [
                    // Country List
                    ValueListenableBuilder<List<Country>>(
                      valueListenable: filteredCountries,
                      builder: (context, countries, _) {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: countries.length,
                          itemBuilder: (context, index) {
                            final country = countries[index];
                            return ListTile(
                              leading: Text(
                                country.flagEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              title: Text(country.name),
                              onTap: () {
                                controller.selectedCountry.value =
                                    "${country.flagEmoji} ${country.name}";
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    ),

                    // Alphabetical Index
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 24,
                        alignment: Alignment.center,
                        child: ValueListenableBuilder<List<Country>>(
                          valueListenable: filteredCountries,
                          builder: (context, countries, _) {
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(26, (i) {
                                  final letter =
                                      String.fromCharCode(65 + i); // A-Z
                                  return GestureDetector(
                                    onTap: () {
                                      final index = countries.indexWhere(
                                          (country) => country.name
                                              .toUpperCase()
                                              .startsWith(letter));
                                      if (index != -1) {
                                        scrollController.animateTo(
                                          index * 56.0,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Text(
                                        letter,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
 