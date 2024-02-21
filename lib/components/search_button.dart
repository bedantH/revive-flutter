import 'package:flutter/material.dart';

class TakePictureButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool freezed;

  const TakePictureButton({super.key, required this.onPressed, required this.freezed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(side: const BorderSide(width: 3,color: Colors.white),borderRadius: BorderRadius.circular(100)),
        child: freezed?const Icon(
          Icons.close,
          color: Colors.black,
        ):const Icon(
          Icons.search,
          color: Colors.black,
        ),
      ),
    );
  }
}