import 'package:flutter/material.dart';

class FullScreenImageDialog extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero, // Remove any default padding
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop(); // Close the dialog on tap
        },
        child: Container(
          width: MediaQuery.of(context).size.width, // Set width to screen width
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
