import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryCard extends StatelessWidget {
  final dynamic item;

  const HistoryCard({super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        border: Border.all(color: const Color(0x1F019344)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'],
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color(0xFF12372A),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                )
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          item['response'][0]['methods'].length>0?
          Text(
            "Recycle",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color(0xFF12372A),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600
                )
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ):const SizedBox(height: 0),
          item['response'][0]['methods'].length>0?
          Text(
            item['response'][0]['methods'][0]['name'],
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color(0xFF12372A),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400
                )
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ):const SizedBox(height: 0),
          item['response'][0]['methods'].length>1?Text(
            item['response'][0]['methods'][1]['name'],
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color(0xFF12372A),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400
                )
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ):const SizedBox(height: 0),

          const SizedBox(height: 10),
          item['response'][1]['methods'].length>0?
          Text(
            "Reuse",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color(0xFF12372A),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600
                )
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ):const SizedBox(height: 0),
          item['response'][1]['methods'].length>0?
          Text(
            item['response'][1]['methods'][0]['name'],
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color(0xFF12372A),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400
                )
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ):const SizedBox(height: 0),
          item['response'][1]['methods'].length>1?
          Text(
            item['response'][1]['methods'][1]['name'],
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color(0xFF12372A),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400
                )
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ):const SizedBox(height: 0),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
