import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revive/components/common/history_card.dart';

List<Map<String, dynamic>> recyclingCenters = [
  {
    "name": "Panvel Municipal Corporation Recycling Center",
    "address": "Plot No. 123, Sector 4, Panvel, Maharashtra 410206",
    "distance": "1.5 km",
    "contact": "022-27412345",
    "map_link": "https://goo.gl/maps/9h12345678"
  },
  {
    "name": "Shree Ganesh Recycling Center",
    "address": "Plot No. 456, Sector 5, Panvel, Maharashtra 410206",
    "distance": "2.5 km",
    "contact": "022-27412345",
    "map_link": "https://goo.gl/maps/9h12345678"
  },
  {
    "name": "Shree Ganesh Recycling Center",
    "address": "Plot No. 456, Sector 5, Panvel, Maharashtra 410206",
    "distance": "2.5 km",
    "contact": "022-27412345",
    "map_link": "https://goo.gl/maps/9h12345678"
  },
  {
    "name": "Shree Ganesh Recycling Center",
    "address": "Plot No. 456, Sector 5, Panvel, Maharashtra 410206",
    "distance": "2.5 km",
    "contact": "022-27412345",
    "map_link": "https://goo.gl/maps/9h12345678"
  },
  {
    "name": "Shree Ganesh Recycling Center",
    "address": "Plot No. 456, Sector 5, Panvel, Maharashtra 410206",
    "distance": "2.5 km",
    "contact": "022-27412345",
    "map_link": "https://goo.gl/maps/9h12345678"
  },
  {
    "name": "Shree Ganesh Recycling Center",
    "address": "Plot No. 456, Sector 5, Panvel, Maharashtra 410206",
    "distance": "2.5 km",
    "contact": "022-27412345",
    "map_link": "https://goo.gl/maps/9h12345678"
  }
];

class HistoryLayout extends StatelessWidget {
  final ScrollController scrollController;
  final List<dynamic> prevResult;
  const HistoryLayout(
      {super.key, required this.scrollController, required this.prevResult});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(prevResult);
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: prevResult.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF12372A),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        "Past Scans",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Color(0xFF12372A),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 3.0),
                        itemCount: (prevResult ?? []).length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> current = prevResult[index];
                          return HistoryCard(item: current);
                        },
                      ),
                    ),
                  ),
                ],
              )
            : EmptyStateWidget());
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage("images/empty_state_inbox.png")),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 300,
            child: Text("Not sure what's recyclable? No worries! Just click an image and we'll be your recycling guide.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0x80000000),
                  fontWeight: FontWeight.w500

              ),),
          ),

        ],
      ),
    );
  }
}
