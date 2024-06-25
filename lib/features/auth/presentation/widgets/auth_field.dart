import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscure = false,
    this.validator });
  final String hintText;
  final TextEditingController controller;
  final bool obscure;
  String? _defaultValidator(String? value) {
  if (value == null || value.isEmpty) {
  return '$hintText iw missing';
  }
  return null;
  }

  String? Function(String? value)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      controller: controller,
      validator: validator ?? _defaultValidator,
      decoration: InputDecoration(

        hintText:hintText
      ),
    );
  }
}
