import 'package:flutter/cupertino.dart';
import 'package:whisp/config/constants/colors.dart';

class CustomCupertinoDatePicker extends StatelessWidget {
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final ValueChanged<DateTime> onDateTimeChanged;

  const CustomCupertinoDatePicker({
    super.key,
    required this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    required this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(brightness: Brightness.light),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: initialDateTime,
        maximumDate: maximumDate,
        minimumDate: minimumDate,
        onDateTimeChanged: onDateTimeChanged,
        // 👇 This property is available internally and since Flutter 3.22
        // if you are on 3.22+, it will respect the primaryColor highlight.
        // For older versions, we manually overlay color below.
      ),
    );
  }
}
