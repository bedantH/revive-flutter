import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagButton extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final IconData icon;
  final Color bgColor;
  final int index;
  final Color iconColor;
  final Color textColor;

  const TagButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onClick,
    required this.bgColor,
    required this.iconColor,
    required this.index,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: index == 0 ? const EdgeInsets.only(left: 20.0) : index == 3 ? const EdgeInsets.only(left: 10.0, right: 20.0) : const EdgeInsets.only(left: 10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: iconColor, size: 20.0,),
              const SizedBox(width: 10.0),
              Text(text, style: GoogleFonts.poppins(
                textStyle:  TextStyle(
                  fontSize: 13.0,
                  color: textColor, // Set the color to white
                ),
              ))
            ],
          ),
        )
      ),
    );
  }
}
