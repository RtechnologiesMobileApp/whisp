import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/core/widgets/custom_back_button.dart';
import 'package:whisp/core/widgets/custom_button.dart';
import 'package:whisp/core/widgets/custom_text_field.dart';
import 'package:whisp/features/profile/controller/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.put(EditProfileController());

  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController genderController;

  @override
  void initState() {
    super.initState();
    // 🟢 Fix: Load fresh user data from session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadUser();
      // Update controllers after user is loaded
      final user = controller.user.value;
      nameController.text = user.name;
      dobController.text = user.dob ?? '';
      genderController.text = user.gender ?? '';
    });

    // Initialize with current data first to avoid null errors if any
    final user = controller.user.value;
    nameController = TextEditingController(text: user.name);
    dobController = TextEditingController(text: user.dob ?? '');
    genderController = TextEditingController(text: user.gender ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar Picker
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() {
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight, // edit icon top-right
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: controller.selectedImage.value != null
                          ? FileImage(controller.selectedImage.value!)
                          : (controller.user.value.profilePic != null &&
                                controller.user.value.profilePic!.isNotEmpty)
                          ? NetworkImage(controller.user.value.profilePic!)
                          : const AssetImage("assets/images/default_avatar.png")
                                as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 25),
            // Full Name
            CustomTextField(
              icon: Icons.person_2_outlined,
              controller: nameController,
              hint: 'Full Name',
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  dobController.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  icon: Icons.calendar_month,
                  controller: dobController,
                  hint: 'Date of Birth (YYYY-MM-DD)',
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Gender
            // CustomTextField(
            //   icon: Icons.male_outlined,
            //   controller: genderController,
            //   hint: 'Gender',
            // ),
            //   const SizedBox(height: 16),
            // Country
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
                      const Icon(Icons.flag_outlined, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        controller.selectedCountry.value.isEmpty
                            ? "Select Country"
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
            const SizedBox(height: 30),
            // Update Button
            Obx(
              () => CustomButton(
                text: "Update Profile",
                isLoading: controller.isLoading.value,
                onPressed: () {
                  controller.updateProfile(
                    fullName: nameController.text.trim(),
                    dateOfBirth: dobController.text.trim(),
                    // gender: genderController.text.trim(),
                    country: controller.selectedCountry.value.trim(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCountryPickerWithIndex(
    BuildContext context,
    EditProfileController controller,
  ) {
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
                    prefixIcon: const Icon(Icons.search, color: Colors.purple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    filteredCountries.value = allCountries
                        .where(
                          (country) => country.name.toLowerCase().contains(
                            value.toLowerCase(),
                          ),
                        )
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
                                // controller.selectedCountry.value =
                                //     "${country.flagEmoji} ${country.name}";
                                controller.selectedCountry.value = country.name;

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
                                  final letter = String.fromCharCode(
                                    65 + i,
                                  ); // A-Z
                                  return GestureDetector(
                                    onTap: () {
                                      final index = countries.indexWhere(
                                        (country) => country.name
                                            .toUpperCase()
                                            .startsWith(letter),
                                      );
                                      if (index != -1) {
                                        scrollController.animateTo(
                                          index * 56.0,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2.0,
                                      ),
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
