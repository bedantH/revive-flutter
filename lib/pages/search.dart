import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revive/components/common/location_card.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

List<Map<String, dynamic>> details = [
  {
    "title":"recycle",
    "methods": [
      {
        "name": "Bottle-to-bottle recycling",
        "steps": [
          "Rinse the bottle to remove any residual liquid.",
          "Remove the cap and label.",
          "Flatten the bottle by stepping on it or running it over with a car.",
          "Place the bottle in a recycling bin or take it to a recycling center."
        ],
        "resources": [
          "https://www.wikihow.com/Recycle-Plastic-Bottles",
          "https://www.youtube.com/watch?v=9h12345678"
        ]
      },
      {
        "name": "Chemical recycling",
        "steps": [
          "Collect and sort the plastic bottles.",
          "Shred the bottles into small pieces.",
          "Heat the pieces to a high temperature in the absence of oxygen.",
          "Cool the resulting liquid and collect the plastic.",
          "Purify the plastic and use it to create new products."
        ],
        "resources": [
          "https://www.bpf.co.uk/plastics-循環/chemical-recycling.aspx",
          "https://www.youtube.com/watch?v=9h12345678"
        ]
      }
    ]
  },
  {
    "title":"reuse",
    "methods": [
      {
        "name": "Use as a plant pot",
        "steps": [
          "Cut the bottle in half.",
          "Fill the bottom half with soil.",
          "Plant a seed or seedling in the soil.",
          "Water the plant regularly."
        ],
        "resources": [
          "https://www.wikihow.com/Make-a-Plastic-Bottle-Planter",
          "https://www.youtube.com/watch?v=9h12345678"
        ]
      },
      {
        "name": "Use as a storage container",
        "steps": [
          "Clean the bottle thoroughly.",
          "Remove the cap and label.",
          "Use the bottle to store small items such as screws, nails, or paper clips.",
          "You can also use the bottle to store liquids such as water or juice."
        ],
        "resources": [
          "https://www.wikihow.com/Reuse-Plastic-Bottles",
          "https://www.youtube.com/watch?v=9h12345678"
        ]
      }
    ]
  },
  {
    "title":'nearest recycling stations',
    "station": [
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
      }
    ]
  }
];

class SearchLayout extends StatelessWidget {
  final ScrollController scrollController;
  const SearchLayout({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF12372A),),
              const SizedBox(width: 10.0),
              Text("Search", style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Color(0xFF12372A), fontSize: 16.0, fontWeight: FontWeight.w500
                  )
              ),),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.0),
                itemCount: details.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> current = details[index];
                  if(index!=2) {
                    return ExpansionTile(
                      title: Text(current["title"].toUpperCase(),
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF12372A),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600,

                            )
                        ),),
                      children: [
                        Container(
                          color: Colors.black12,
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.0),
                              itemCount: current["methods"]!=null?current["methods"].length:0,
                              itemBuilder: (BuildContext context, int index){
                                Map<String, dynamic> cur = current["methods"][index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cur['name'],style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF12372A), fontSize: 16.0, fontWeight: FontWeight.w500
                                        )
                                      )
                                    ),
                                    ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        controller: scrollController,
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.0),
                                        itemCount: cur["steps"]?.length ?? 0,
                                        itemBuilder: (BuildContext context, int index){
                                          String curStep = cur["steps"][index];
                                          return Text((index+1).toString()+". "+curStep);
                                        }
                                    ),

                                    ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        controller: scrollController,
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.0),
                                        itemCount: cur["resources"]?.length ?? 0,
                                        itemBuilder: (BuildContext context, int index){
                                          String curUrl = cur["resources"][index];
                                          return GestureDetector(
                                            onTap: (){
                                              launch(curUrl);
                                            },
                                            child: Text(
                                                curUrl,
                                            style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                          color: Color(0xFF12372A), fontSize: 16.0, fontWeight: FontWeight.w400, decoration: TextDecoration.underline
                                          ))

                                            ),
                                          );
                                        }
                                    ),
                                    const Text("")

                                  ],
                                );
                              }
                          ),
                        )
                      ],
                    );
                  }
                  else{
                    return ExpansionTile(
                      title: Text(current["title"].toUpperCase(),
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF12372A),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w600,

                            )
                        ),),
                      children: [
                        Container(
                          color: Colors.black12,
                          padding:const EdgeInsets.all(20),
                          width: double.infinity,
                          child:  ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.0),
                              itemCount: current["station"]!=null?current["station"].length:0,
                              itemBuilder: (BuildContext context, int index){
                                Map<String, dynamic> curStation = current["station"][index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(curStation['name']??""),
                                    Text(curStation['address']??""),
                                    Text(curStation['distance']??""),
                                    Text(curStation['contact']??""),
                                    GestureDetector(
                                        onTap: (){
                                        launch(curStation['map_link']??'');
                                        },
                                        child: Text(
                                            curStation['map_link']??'',
                                        style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                        color: Color(0xFF12372A), fontSize: 16.0, fontWeight: FontWeight.w400, decoration: TextDecoration.underline
                                        ))

                                        ),
                                      ),
                                    const Text("")



                                  ],
                                );

                              }
                          )
                        )
                      ],
                    );
                  }
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
