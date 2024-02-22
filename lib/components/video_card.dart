import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HorizontalItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final int index;
  final String videoId;

  const HorizontalItemWidget(
      {super.key,
      required this.videoId,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.index});

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launch("https://www.youtube.com/watch?v=$videoId/");
      },
      child: Container(
        width: 320.0,
        padding: const EdgeInsets.all(10.0),
        margin: index == 0
            ? const EdgeInsets.only(left: 0.0)
            : const EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: const Color(0x1F019344)
            ),
        )

        ,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
