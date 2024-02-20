import 'package:flutter/material.dart';

class TakePictureButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TakePictureButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.search,
          color: Colors.black,
        ),
      ),
    );
  }
}