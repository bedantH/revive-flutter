import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revive/components/bottom_panel.dart';
import 'package:revive/components/header.dart';
import 'package:revive/components/search_button.dart';
import 'package:revive/pages/forum.dart';
import 'package:revive/pages/history.dart';
import 'package:revive/pages/locations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
       SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0), // Example color
      ),
    );

    return MaterialApp(
      routes: {
        '/': (context) => const CameraApp(),
      },
      initialRoute: '/',
    );
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();


}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  final panelController = PanelController();
  bool freezeCam = false;
  dynamic picture = null;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch(e.code) {
          case 'CameraAccessDenied':
            if (kDebugMode) {
              print("Access was denied");
            }
            break;
          default:
            if (kDebugMode) {
              print(e.description);
            }
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.84;
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.13;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SlidingUpPanel(
        controller: panelController,
        color: const Color(0xFF8DA179),
        panelBuilder: (ScrollController controller) => BottomPanel(
          scrollController: controller,
          panelController: panelController,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpen,
        body: Theme(
            data: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            child: Stack(children: [
              SizedBox(
                  height: double.infinity,
                  child: freezeCam&&picture!=null? Image.memory(
                    base64Decode(picture),
                    fit: BoxFit.cover,
                  ) :CameraPreview(_controller)
              ),
              const Header(),
              const Positioned(
                  top: 180,
                  width: 260,
                  height: 260,
                  left: 50,
                  child: Image(image: AssetImage("images/scan.png"))
              ),
              Positioned(bottom: 130, right: 150, left: 150, child: TakePictureButton(freezed:freezeCam&&picture!=null,onPressed: () async{
                if(freezeCam&&picture!=null){
                  setState(() {
                    freezeCam=false;
                  });
                }
                else{
                if(!_controller.value.isInitialized){
                  return null;
                }
                if(_controller.value.isTakingPicture){
                  return null;
                }
                try{
                  await _controller.setFlashMode(FlashMode.off);
                  XFile pic = await _controller.takePicture();

                   //Xfile
                  List<int> imageBytes = await pic.readAsBytes();
                  String base64Image = base64Encode(imageBytes);
                  setState(()  {
                    picture = base64Image;
                    freezeCam = true;
                  });
                  print("Image base64: $base64Image");


                } on CameraException catch(e){
                  debugPrint("Error: $e");
                  return null;
                }
              }}))
            ])
        )
      )
    );
  }
}

class ScanMarkerOverlayPainter extends CustomPainter {
  @override
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double padding = 20.0;
    const double cornerRadius = 8.0;
    final double width = size.width - padding * 2;
    final double height = size.height - padding * 2;

    final Path path = Path()
      ..moveTo(padding, padding + cornerRadius)
      ..arcToPoint(const Offset(padding + cornerRadius, padding), radius: const Radius.circular(cornerRadius), clockwise: false)
      ..lineTo(padding + width - cornerRadius, padding)
      ..arcToPoint(Offset(padding + width, padding + cornerRadius), radius: const Radius.circular(cornerRadius), clockwise: false)
      ..lineTo(padding + width, padding + height - cornerRadius)
      ..arcToPoint(Offset(padding + width - cornerRadius, padding + height), radius: const Radius.circular(cornerRadius), clockwise: false)
      ..lineTo(padding + cornerRadius, padding + height)
      ..arcToPoint(Offset(padding, padding + height - cornerRadius), radius: const Radius.circular(cornerRadius), clockwise: false)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}