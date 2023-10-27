import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/services/Recognition/camera_service.dart';
import 'package:sas_hima/services/Recognition/face_detector.dart';
import 'package:sas_hima/services/Recognition/mlservice.dart';
import 'package:sas_hima/utils/locator.dart';
import 'package:sas_hima/utils/utils_dialog.dart';
import 'package:sas_hima/views/register_face/view_register_face2.dart';
import 'package:sas_hima/widgets/camera_header.dart';
import 'package:sas_hima/widgets/face_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class RegisterFaceView1 extends StatefulWidget {
  const RegisterFaceView1({Key? key}) : super(key: key);

  @override
  State<RegisterFaceView1> createState() => _RegisterFaceView1State();
}

class _RegisterFaceView1State extends State<RegisterFaceView1> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;
  String? base64Image;
  bool _detectingFaces = false;
  bool pictureTaken = false;
  bool _initializing = false;
  bool _saving = false;
  bool _buttonVisible = true;
  String? base64;
  String? mimetype;
  String? facepoint1;

  // service injection
  final FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  final CameraService _cameraService = locator<CameraService>();
  final MLService _mlService = locator<MLService>();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    _faceDetectorService.initialize();
    setState(() => _initializing = false);
    _frameFaces();
  }

  Future<bool> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );
      return false;
    } else {
      _saving = true;
      await Future.delayed(const Duration(milliseconds: 200));
      XFile? file = await _cameraService.takePicture();
      imagePath = file?.path;
      await _cameraService.convertBase64(file);
      await _cameraService.getMime(file);
      List predictedData = _mlService.predictedData;
      base64 = _cameraService.base64Image;
      mimetype = _cameraService.mimeType;
      facepoint1 = jsonEncode(predictedData);
      if (mounted) {
        if (facepoint1 != "[]") {
          _mlService.setPredictedData([]);
          dialog(context);
        } else {
          UtilsDialog.flushBarErrorMessage(
              "Terjadi kesalahan", 'coba lagi', context);
          _reload();
        }
      }
      setState(() {
        _buttonVisible = true;
        pictureTaken = true;
      });
      return true;
    }
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();
    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;
        _detectingFaces = true;
        try {
          await _faceDetectorService.detectFacesFromImage(image);
          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() {
              faceDetected = _faceDetectorService.faces[0];
              if ((faceDetected!.headEulerAngleY! > 10 ||
                  faceDetected!.headEulerAngleY! < -10)) {
                setState(() {
                  _buttonVisible = true;
                });
              } else {
                setState(() {
                  _buttonVisible = false;
                });
              }
            });

            if (_saving) {
              _mlService.setCurrentPrediction(image, faceDetected);
              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              _buttonVisible = true;
              faceDetected = null;
            });
          }
          _detectingFaces = false;
        } catch (e) {
          _detectingFaces = false;
        }
      }
    });
  }

  _onBackPressed() {
    _cameraService.dispose();
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      pictureTaken = false;
    });
    _start();
  }

  @override
  Widget build(BuildContext context) {
    const double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget body;

    if (_initializing) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing && pictureTaken) {
      body = SizedBox(
        width: width,
        height: height,
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(mirror),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(imagePath!)),
            )),
      );
    }

    if (!_initializing && !pictureTaken) {
      body = Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: SizedBox(
                width: width,
                height:
                    width * _cameraService.cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(_cameraService.cameraController!),
                    CustomPaint(
                      painter: FacePainter(
                          face: faceDetected, imageSize: imageSize!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          body,
          CameraHeader(
            "Foto pertama",
            onBackPressed: _onBackPressed,
            vermuk: false,
          ),
          Positioned(
            bottom: 100,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.black12,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Pastikan wajah anda lurus kedepan',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_buttonVisible
          ? FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              onShot();
            },
            child: const Icon(Icons.camera_alt),
          )
          : FloatingActionButton(
            backgroundColor: Colors.grey,
            onPressed: () {},
            child: const Icon(Icons.camera_alt_outlined),
          ),
    );
  }

  dialog(BuildContext context) {
    Uint8List bytes = base64Decode(base64!);
    const double mirror = math.pi;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 370,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Foto wajah pertama',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: const Border(
                          top: BorderSide(width: 1, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                          left: BorderSide(width: 1, color: Colors.grey),
                          right: BorderSide(width: 1, color: Colors.grey),
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(mirror),
                              child: Image.memory(
                                bytes,
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: LottieBuilder.asset(lottieCheck3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Lanjut untuk foto kedua?',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _reload();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text("Ulangi")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: RegisterFaceView2(
                                      facepoint1: '$facepoint1',
                                      base64String1: '$base64',
                                      mimetype1: '$mimetype',
                                  ),
                                  type: PageTransitionType.fade));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text("Lanjut"))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
