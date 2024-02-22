import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revive/components/bottom_panel.dart';
import 'package:revive/components/common/loading.dart';
import 'package:revive/components/header.dart';
import 'package:revive/components/search_button.dart';
import 'package:revive/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';

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
  List<Map<String, dynamic>> vid_res = [];
  List<dynamic> prevResults = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    dio = Dio();
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      var temp = jsonDecode((await _prefs).getString('history') ?? "[]");
      if (kDebugMode) {
        print(temp.length);
      }
      var len = temp.length;
      if (len > 0) {
        Fluttertoast.showToast(
            msg:
                "You have scanned $len items, please visit past scans for further information.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      setState(() {
        prevResults = temp;
      });
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
            color: const Color(0xFF8DA179),
            panelBuilder: (ScrollController controller) => BottomPanel(
                  res: res,
                  vid_res: vid_res,
                  prevResult: prevResults,
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

                                  Response response = await dio.post(
                                      'https://revive-ai-be.onrender.com/ai/response/all/',
                                      options: Options(headers: {
                                        HttpHeaders.contentTypeHeader:
                                            "application/json"
                                      }),
                                      data: {
                                        "location": "Panvel, Maharashtra",
                                        "mimeType": "image/jpeg",
                                        "image": base64Image,
                                      });

                                  if (response.data.toString() != "") {
                                    Utils(context).stopLoading();
                                    if (kDebugMode) {
                                      print(
                                        "Response: ${response.data["message"]}");
                                      print(response.data['data']);

                                    }

                                    Response videos = await dio.get(
                                        'https://revive-ai-be.onrender.com/search?q=recycle ${response.data['data']['object']}');
                                    if (kDebugMode) {
                                      print(response.data['data']['object']);
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
                                        ];
                                      }

                                      if (videos.statusCode == 200) {
                                        vid_res = [...videos.data["items"]];
                                        print(vid_res);
                                      }
                                    });
                                    try {
                                      var temp = jsonDecode(
                                          (await _prefs).getString('history') ??
                                              "[]");
                                      var uuid = Uuid();
                                      temp = [
                                        {
                                          "id": uuid.v4(),
                                          "name": response.data['data']
                                              ['object'],
                                          "response": res,
                                          "complete": false,
                                        },
                                        ...temp
                                      ];
                                      setState(() {
                                        prevResults = temp;
                                      });
                                      print(temp.length);
                                      (await _prefs).setString(
                                          'history', jsonEncode(temp));
                                      // jsonEncode(response.data)
                                    } catch (e) {
                                      print(
                                          "Error storing response in Shared Preferences: $e");
                                    }
                                    panelController.open();
                                  }
                                } catch (e) {
                                  print("Error: $e");
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
