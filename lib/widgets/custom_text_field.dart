import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.hintText,
    this.inputType,
    this.onChanged,
    this.obscureText = false,
    required this.hasIcon,
    this.validator,
    this.onTap,
  }) : super(key: key);

  final Function(String)? onChanged;
  final String? hintText;
  final TextInputType? inputType;
  final bool obscureText;
  final bool hasIcon;
  final FormFieldValidator<String>? validator;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        validator: validator,
        obscureText: obscureText,
        onChanged: onChanged,
        keyboardType: inputType,
        decoration: InputDecoration(
          suffixIcon: hasIcon
              ? GestureDetector(
            onTap: () {
              onTap?.call();
            },
            child: const Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.white,
            ),
          )
              : const SizedBox(width: 0, height: 0),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
