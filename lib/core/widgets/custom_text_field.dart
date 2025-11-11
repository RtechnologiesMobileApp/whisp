import 'package:flutter/material.dart';
import 'package:whisp/config/constants/colors.dart';
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      keyboardType: widget.keyboardType,
    
      // autovalidateMode: AutovalidateMode.always, // 🔥 always validate
      validator: widget.validator, // 🔥 built-in validator
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(widget.icon, color: Colors.grey[600]),
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:whisp/config/constants/colors.dart';

// class CustomTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hint;
//   final IconData icon;
//   final bool isPassword;
//   final TextInputType keyboardType;

//   // ✅ Optional validator function
//   final String? Function(String?)? validator;

//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.hint,
//     required this.icon,
//     this.isPassword = false,
//     this.keyboardType = TextInputType.text,
//     this.validator, // new optional validator
//   });

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _isObscured = true;
//   String? _errorText;

//   @override
//   void initState() {
//     super.initState();
//     _isObscured = widget.isPassword;

//     // Listen to changes and validate if validator is provided
//     widget.controller.addListener(() {
//       if (widget.validator != null) {
//         final error = widget.validator!(widget.controller.text);
//         setState(() {
//           _errorText = error;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: widget.controller,
//           obscureText: widget.isPassword ? _isObscured : false,
          
//           keyboardType: widget.keyboardType,
//            autovalidateMode: AutovalidateMode.always, 
//           decoration: InputDecoration(
//             prefixIcon: Padding(
//               padding: const EdgeInsets.only(left: 10.0),
//               child: Icon(widget.icon, color: Colors.grey[600]),
//             ),
//             hintText: widget.hint,
//             hintStyle: TextStyle(color: AppColors.grey),
//             filled: true,
//             fillColor: const Color(0xFFF0F0F0),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 18,
//               horizontal: 16,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(24),
//               borderSide: BorderSide.none,
//             ),
//             suffixIcon: widget.isPassword
//                 ? GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _isObscured = !_isObscured;
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 10.0),
//                       child: Icon(
//                         _isObscured ? Icons.visibility_off : Icons.visibility,
//                         color: Colors.black,
//                       ),
//                     ),
//                   )
//                 : null,
            
//             errorText: _errorText,
//           ),
//         ),
       
//       ],
//     );
//   }
// }

 