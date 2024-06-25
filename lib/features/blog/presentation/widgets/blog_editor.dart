import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  const BlogEditor({super.key, required this.controller, required this.hintText,this.lined = true});
  final TextEditingController controller;
  final String hintText;
  final bool lined;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText
      ),
      maxLines: lined ? 1 : null,
      validator: (value){
        value = value?.trim();
        if(value == null || value.isEmpty){
          return '$hintText is missing';

        } else if(!lined && value.length < 10) {
          return 'put more $hintText';
        } else {
          return null;
        }

      },
    );
  }
}
