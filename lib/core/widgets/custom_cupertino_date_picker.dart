import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/features/auth/controllers/signup_controller.dart';

class CustomColoredDatePicker extends StatefulWidget {
  const CustomColoredDatePicker({super.key});

  @override
  State<CustomColoredDatePicker> createState() =>
      _CustomColoredDatePickerState();
}

class _CustomColoredDatePickerState extends State<CustomColoredDatePicker> {
  int selectedMonth = DateTime.now().month - 1;
  int selectedDay = DateTime.now().day - 1;
  int selectedYear = DateTime.now().year - 1900;

  final months = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final years = List.generate(
    DateTime.now().year - 1900 + 1,
    (index) => 1900 + index,
  );
  final days = List.generate(31, (index) => index + 1);

  void _updateSelectedDate() {
  final controller = Get.find<SignupController>();
  final selectedDate = DateTime(
    years[selectedYear],
    selectedMonth + 1,
    days[selectedDay],
  );
  controller.selectedDate.value = selectedDate;
}


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 216, // iOS default height
      child: Row(
        children: [
          // Month picker
          Expanded(
            flex: 3,
            child: CupertinoPicker(
              itemExtent: 36,
              scrollController: FixedExtentScrollController(
                initialItem: selectedMonth,
              ),
              selectionOverlay: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    months[selectedMonth],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
             // Month picker
onSelectedItemChanged: (index) {
  setState(() {
    selectedMonth = index;
    _updateSelectedDate();
  });
},

              children: months
                  .map(
                    (month) => Center(
                      child: Text(
                        month,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Day picker
          Expanded(
            flex: 2,
            child: CupertinoPicker(
              itemExtent: 36,
              scrollController: FixedExtentScrollController(
                initialItem: selectedDay,
              ),
              selectionOverlay: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary, // same highlight color
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Center(
                  child: Text(
                    days[selectedDay].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
             // Day picker
onSelectedItemChanged: (index) {
  setState(() {
    selectedDay = index;
    _updateSelectedDate();
  });
},

              children: days
                  .map(
                    (day) => Center(
                      child: Text(
                        day.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Year picker
          Expanded(
            flex: 2,
            child: CupertinoPicker(
              itemExtent: 36,
              scrollController: FixedExtentScrollController(
                initialItem: selectedYear,
              ),
              selectionOverlay: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary, // same highlight color
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    years[selectedYear].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
             // Year picker
onSelectedItemChanged: (index) {
  setState(() {
    selectedYear = index;
    _updateSelectedDate();
  });
},

              children: years
                  .map(
                    (year) => Center(
                      child: Text(
                        year.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
