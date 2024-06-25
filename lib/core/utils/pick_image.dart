import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage([isGallery = true]) async {
  try {
    final xFile = await ImagePicker().pickImage(
      imageQuality: 30,
      source: isGallery ? ImageSource.gallery : ImageSource.camera,
    );
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
