import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  late BuildContext context;

  Utils(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor:
              Colors.white, // can change this to your prefered color
          children: <Widget>[
            Center(
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(
                          color: Colors.black,
                        ),
                        Text(
                            "Please wait! We're preparing something good for you")
                      ],
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
