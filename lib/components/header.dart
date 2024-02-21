import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 35.0),
        height: 100, // Adjust the height according to your requirements
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(1), // Start color with opacity
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0)// End color with lower opacity
              ],
            ),
        ), // Example color
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox.fromSize(
                  size: const Size(60.0, 60.0),
                  child: const Image(
                    image: AssetImage("images/carbon_sprout.png"),
                  ),
                ),
                Text(
                  'Revive',
                  style: GoogleFonts.yesevaOne(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0
                      )
                  ),
                ),
              ],
            ),

            Row(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       color: const Color(0xFFFBFADA),
                //       borderRadius: BorderRadius.circular(20.0)
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
                //     child: Text("12,000", style: GoogleFonts.poppins(
                //         textStyle: const TextStyle(
                //             color: Color(0xFF12372A)
                //         )
                //     ),
                //     ),
                //   ),
                // ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.white,))
              ],
            )
          ],
        ),
      ),
    );
  }
}
