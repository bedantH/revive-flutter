import 'package:flutter/material.dart';
import 'package:revive/components/tag_button.dart';
import 'package:revive/pages/locations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomPanel extends StatefulWidget {
  final ScrollController scrollController;
  final PanelController panelController;

  const BottomPanel({super.key, required this.scrollController, required this.panelController});

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
    const List<String> tabs = ["Locations", "Past Scans", "Forums"];
    const List<IconData> icons = [Icons.location_on_outlined, Icons.history, Icons.forum_outlined];
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
                color: Color(0xFF8DA179),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
            ),
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
                              bgColor: activeIndex == index ?  const Color(0xFF1E4B3C) : const Color(0xFF436850),
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
                      LocationsLayout(scrollController: widget.scrollController),
                      Container(color: Colors.blue),
                      Container(color: Colors.green),
                    ],
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }

  void togglePanel() => {
    if (widget.panelController.isPanelOpen) {
      widget.panelController.close()
    } else {
      widget.panelController.open()
    }
  };

  Widget buildHandle() => GestureDetector(
    onTap: togglePanel,
    child: Center(
      child: Container(
        width: 50,
        height: 5,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0)
        ),
      ),
    ),
  );
}


