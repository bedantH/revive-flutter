import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320.0,
        height: 130.0,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0)
        ),
        child: const Column(
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 15.0),
            Text("Please wait!, We're preparing something good for you!")
          ],
        ),
      ),
    );
  }
}
