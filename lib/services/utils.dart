import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<File?> pickImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      return image;
    }
  }
}
