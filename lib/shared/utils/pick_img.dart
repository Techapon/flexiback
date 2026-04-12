import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future pickImageGallery() async {

  final ImagePicker picker = ImagePicker();

  final XFile? file = await picker.pickImage(source: ImageSource.gallery);

  if (file == null) return null;

  return File(file.path);
}