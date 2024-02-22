import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchURL(String url) async {
  Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

class Utils {
  late BuildContext context;

  Utils(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white
              .withOpacity(0), // can change this to your preferred color
          children: <Widget>[
            Center(
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 12.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                            width: 30.0,
                            child: Center(child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xDF000000)
                            )),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                              "Please wait! We're preparing something good for you",
                          textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0x81000000)
                            ),
                          )
                        ],
                      ),
                    )))
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }
}
