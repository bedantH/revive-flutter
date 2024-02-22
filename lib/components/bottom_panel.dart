import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:revive/components/tag_button.dart';
import 'package:revive/pages/history.dart';
import 'package:revive/pages/locations.dart';
import 'package:revive/pages/search.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomPanel extends StatefulWidget {
  final PanelController panelController;
  final ScrollController scrollController;
  final List<Map<String, dynamic>> res;
  final List<Map<String, dynamic>> vid_res;
  final List<dynamic> prevResult;

  const BottomPanel(
      {super.key,
      required this.scrollController,
      required this.panelController,
      required this.res,
      required this.prevResult,
      required this.vid_res});

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  int activeIndex = 0;
  late ScrollController _scrollController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: activeIndex);
  }

  @override
  Widget build(BuildContext context) {
    const List<String> tabs = ["Search", "Locations", "Past Scans"];
    const List<IconData> icons = [
      Icons.search,
      Icons.location_on_outlined,
      Icons.history,
    ];
    _scrollController = ScrollController();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the position of the active tab after the layout is built
      if (_scrollController.hasClients) {
        final double tabWidth = MediaQuery.of(context).size.width / tabs.length;
        final double targetOffset = activeIndex * tabWidth;
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
            decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Column(
              children: [
                buildHandle(),
                Padding(
                  padding: const EdgeInsets.only(top: 17.0, bottom: 17.0),
                  child: SizedBox(
                    height: 50.0, // Adjust the height according to your needs
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: tabs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            TagButton(
                              index: index,
                              text: tabs[index],
                              icon: icons[index],
                              onClick: () {
                                setState(() {
                                  activeIndex = index;
                                  _pageController.jumpToPage(index);
                                });
                              },
                              bgColor: activeIndex == index
                                  ? const Color(0xff019344)
                                  : const Color(0x1A019344),
                              iconColor: activeIndex == index
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF2CB57B),
                              textColor: activeIndex == index
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF2CB57B),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 540, // Adjust the height according to your needs
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    children: [
                      SearchLayout(
                        scrollController: widget.scrollController,
                        details: widget.res,
                        videos: widget.vid_res,
                      ),
                      LocationsLayout(
                          scrollController: widget.scrollController),
                      HistoryLayout(
                          scrollController: widget.scrollController,
                          prevResult: widget.prevResult),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  void togglePanel() => {
        if (widget.panelController.isPanelOpen)
          {widget.panelController.close()}
        else
          {widget.panelController.open()}
      };

  Widget buildHandle() => GestureDetector(
        onTap: togglePanel,
        child: Center(
          child: Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: const Color(0x38000000),
                borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
      );


}
