import 'package:flutter/material.dart';

class CustomFormfield extends StatelessWidget {
  final String hintText, labelText;
  final double height;
  final RegExp regexp;
  final bool obscureText;
  final void Function(String?) onSaved;

  const CustomFormfield({super.key,
    required this.labelText,
    required this.hintText,
    required this.height,
    required this.regexp,
    required this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureText,
        validator: (value){
          if (value != null && regexp.hasMatch(value)){
            return null;
          }
          return "Enter a valid ${labelText}";
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
      ),
    );
  }
}
