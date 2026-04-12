import 'dart:io';

import 'package:flexiback/shared/entities/image_entity.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageEntity?> pickImageGallery() async {

  final ImagePicker picker = ImagePicker();

  final XFile? picked = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80
  );

  if (picked == null) return null;

  final mimeType = picked.mimeType ?? 'image/jpeg';

  return ImageEntity(file: File(picked.path), type: mimeType);
}