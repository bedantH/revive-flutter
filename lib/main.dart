import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revive/components/bottom_panel.dart';
import 'package:revive/components/common/loading.dart';
import 'package:revive/components/header.dart';
import 'package:revive/components/search_button.dart';
import 'package:revive/components/utils.dart';
import 'package:revive/utils.dart';
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
  bool hasSearched = false;
  dynamic picture;

  bool isLoading = false;
  late final dio;
  List<Map<String, dynamic>> res = [];

  @override
  void initState() {
    dio = Dio();
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
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
            color: const Color(0x15FFFFFF),
            panelBuilder: (ScrollController controller) => BottomPanel(
                  res: res,
                  scrollController: controller,
                  panelController: panelController,
                ),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20.0)),
            minHeight: panelHeightClosed,
            maxHeight: panelHeightOpen,
            body: Theme(
                data: ThemeData(
                  textTheme: GoogleFonts.poppinsTextTheme(),
                ),
                child: Stack(children: [
                  SizedBox(
                      height: double.infinity,
                      child: freezeCam && picture != null
                          ? Image.memory(
                              base64Decode(picture),
                              fit: BoxFit.cover,
                            )
                          : CameraPreview(_controller)),
                  const Header(),
                  const Positioned(
                      top: 180,
                      width: 260,
                      height: 260,
                      left: 50,
                      child: Image(image: AssetImage("images/scan.png"))),
                  Positioned(
                      bottom: 130,
                      right: 150,
                      left: 150,
                      child: TakePictureButton(
                          freezed: freezeCam && picture != null,
                          onPressed: () async {
                            if (freezeCam && picture != null) {
                              setState(() {
                                freezeCam = false;
                              });
                            } else {
                              if (!_controller.value.isInitialized) {
                                return;
                              }
                              if (_controller.value.isTakingPicture) {
                                return;
                              }
                              try {
                                await _controller.setFlashMode(FlashMode.off);
                                XFile pic = await _controller.takePicture();

                                List<int> imageBytes = await pic.readAsBytes();
                                String base64Image = base64Encode(imageBytes);
                                setState(() {
                                  picture = base64Image;
                                  freezeCam = true;
                                });

                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Utils(context).startLoading();

                                  return;
                                  Response response = await dio.post(
                                      'https://2c91-103-206-180-90.ngrok-free.app/ai/response/all/',
                                      options: Options(headers: {
                                        HttpHeaders.contentTypeHeader:
                                            "application/json"
                                      }),
                                      data: {
                                        "location": "Panvel, Maharashtra",
                                        "mimeType": "image/jpeg",
                                        "image": base64Image,
                                      });
                                  Utils(context).stopLoading();

                                  if (response.data.toString() != "") {
                                    hasSearched = true;
                                    if (kDebugMode) {
                                      print(
                                          "Response: ${response.data["message"]}");
                                    }
                                    if (kDebugMode) {
                                      print(response.data['data']);
                                    }
                                    setState(() {
                                      isLoading = false;
                                      if (response.data["code"] == 200) {
                                        res = [
                                          {
                                            "title": 'recycle',
                                            "methods": [
                                              ...response.data['data']
                                                  ["recycling_methods"]
                                            ]
                                          },
                                          {
                                            "title": 'reuse',
                                            "methods": [
                                              ...response.data['data']
                                                  ["reusing_methods"]
                                            ]
                                          },
                                          {
                                            "title":
                                                'nearest recycling stations',
                                            "station": [
                                              ...response.data['data']
                                                  ["nearest_recycling_stations"]
                                            ]
                                          },
                                        ];
                                        if (kDebugMode) {
                                          print(res);
                                        }
                                      }
                                    });
                                    panelController.open();
                                  }
                                } catch (e) {
                                  if (kDebugMode) {
                                    print("Error: $e");
                                  }
                                }
                              } on CameraException catch (e) {
                                debugPrint("Error: $e");
                                return;
                              }
                            }
                          }))
                ]))));
  }
}
