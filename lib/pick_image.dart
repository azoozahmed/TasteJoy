import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  } else {
    print("No Image Selected");
  }
}
Future<Uint8List> getImageUint8List(String imagePath) async {
  ByteData imageData = await rootBundle.load(imagePath);
  Uint8List imageUint8List = imageData.buffer.asUint8List();
  return imageUint8List;
}
