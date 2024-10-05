import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    super.key,
    this.isPasswordField = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Icon prefixIcon;
  final bool isPasswordField;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      obscureText:
          // ignore: avoid_bool_literals_in_conditional_expressions
          widget.isPasswordField && _obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(90)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(90)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(90)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
