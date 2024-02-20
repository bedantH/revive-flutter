  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCard extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  final String contact;
  final String mapLink;

  const LocationCard({super.key,
    required this.name,
    required this.address,
    required this.distance,
    required this.contact,
    required this.mapLink
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
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
          Text(
            address,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color(0xFF12372A),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400
                )
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: const Color(0xFF12372A),
              borderRadius: BorderRadius.circular(12.0)
            ),
            child: Text(
              distance,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400
                  )
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF12372A), size: 18,),
              const SizedBox(width: 10.0),
              Text(
                contact,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Color(0xFF12372A),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400
                    )
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Color(0xFF12372A), size: 18,),
              const SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  _launchUrl(Uri.parse(mapLink));
                },
                child: Text(
                  mapLink,
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Color(0xFF12372A),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline
                      )
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )
            ],
          )
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
