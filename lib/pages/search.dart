import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revive/components/video_card.dart';

class SearchLayout extends StatelessWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> details;
  final List<Map<String, dynamic>> videos;

  const SearchLayout(
      {super.key,
      required this.scrollController,
      required this.details,
      required this.videos});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.search,
          //       color: Color(0xFF12372A),
          //     ),
          //     const SizedBox(width: 10.0),
          //     Text(
          //       "Search",
          //       style: GoogleFonts.poppins(
          //           textStyle: const TextStyle(
          //               color: Color(0xFF12372A),
          //               fontSize: 16.0,
          //               fontWeight: FontWeight.w500)),
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 10,
          ),
          videos.length > 1
              ? Text(
                  "Related Videos",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Color(0xFF12372A),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500)),
                )
              : const EmptyStateWidget(),
          Container(
            height: 100.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: ScrollController(),
              itemCount: videos.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> current = videos[index];

                return HorizontalItemWidget(
                  index: index,
                  title: current["snippet"]["title"],
                  description: current["snippet"]["description"],
                  imageUrl: current["snippet"]["thumbnails"]["default"]["url"],
                  videoId: current["id"]["videoId"],
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              child: ListView.builder(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 3.0),
                  itemCount: details.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> current = details[index];
                    if (index != 2) {
                      return ExpansionTile(
                        title: Text(
                          current["title"].toUpperCase(),
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                            color: Color(0xFF12372A),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
                          )),
                        ),
                        children: [
                          Container(
                            color: Colors.black12,
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 3.0),
                                itemCount: current["methods"] != null
                                    ? current["methods"].length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> cur =
                                      current["methods"][index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(cur['name'],
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  color: Color(0xFF12372A),
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          // controller: scrollController,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 3.0),
                                          itemCount: cur["steps"]?.length ?? 0,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String curStep =
                                                cur["steps"][index];
                                            return Text(
                                                "${index + 1}. $curStep");
                                          }),

                                      // ListView.builder(
                                      //     physics: const ClampingScrollPhysics(),
                                      //     shrinkWrap: true,
                                      //     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.0),
                                      //     itemCount: cur["resources"]?.length ?? 0,
                                      //     itemBuilder: (BuildContext context, int index){
                                      //       String curUrl = cur["resources"][index];
                                      //       return GestureDetector(
                                      //         onTap: (){
                                      //           launch(curUrl);
                                      //         },
                                      //         child: Text(
                                      //             curUrl,
                                      //         style: GoogleFonts.poppins(
                                      //       textStyle: const TextStyle(
                                      //       color: Color(0xFF12372A), fontSize: 16.0, fontWeight: FontWeight.w400, decoration: TextDecoration.underline
                                      //       ))
                                      //
                                      //         ),
                                      //       );
                                      //     }
                                      // ),
                                      const Text("")
                                    ],
                                  );
                                }),
                          )
                        ],
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
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
          Image(image: AssetImage("images/empty_state_search.png")),
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

