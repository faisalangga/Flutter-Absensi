import 'package:sas_hima/services/Recognition/camera_service.dart';
import 'package:sas_hima/utils/locator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';

class FaceDetectorService{
  final CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces;
  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
    InputImageData firebaseImageMetadata = InputImageData(
      imageRotation: _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
      inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.yuv_420_888,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes.map(
            (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    // for mlkit 13
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    InputImage firebaseVisionImage = InputImage.fromBytes(
      // bytes: image.planes[0].bytes,
      bytes: bytes,
      inputImageData: firebaseImageMetadata,
    );
    // for mlkit 13

    _faces = await _faceDetector.processImage(firebaseVisionImage);
  }
  // Future<void> detectFacesFromImage1(CameraImage image) async {
  //   InputImageData firebaseImageMetadata = InputImageData(
  //     imageRotation: _cameraService.cameraRotation ?? InputImageRotation.Rotation_0deg,
  //     inputImageFormat: InputImageFormatMethods.fromRawValue(image.format.raw) ?? InputImageFormat.YUV_420_888,
  //     size: Size(image.width.toDouble(), image.height.toDouble()),
  //     planeData: image.planes.map(
  //           (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList(),
  //   );
  //
  //   // for mlkit 13
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (final Plane plane in image.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();
  //   InputImage firebaseVisionImage = InputImage.fromBytes(
  //     // bytes: image.planes[0].bytes,
  //     bytes: bytes,
  //     inputImageData: firebaseImageMetadata,
  //   );
  //   // for mlkit 13
  //
  //   _faces = await _faceDetector.processImage(firebaseVisionImage);
  // }

  // Future<List<Face>> detect(CameraImage image) {
  //   final faceDetector = GoogleMlKit.vision.faceDetector(
  //     const FaceDetectorOptions(
  //       mode: FaceDetectorMode.accurate,
  //     ),
  //   );
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (final Plane plane in image.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();
  //   final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
  //   final inputImageFormat = InputImageFormatMethods.fromRawValue(image.format.raw) ??
  //           InputImageFormat.YUV_420_888;
  //
  //   final planeData = image.planes.map((Plane plane) {
  //       return InputImagePlaneMetadata(
  //         bytesPerRow: plane.bytesPerRow,
  //         height: plane.height,
  //         width: plane.width,
  //       );
  //     },
  //   ).toList();
  //
  //   final inputImageData = InputImageData(
  //     size: imageSize,
  //     imageRotation: _cameraService.cameraRotation ?? InputImageRotation.Rotation_0deg,
  //     inputImageFormat: inputImageFormat,
  //     planeData: planeData,
  //   );
  //   return faceDetector.processImage(InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData),);
  // }
  //
  // Future<void> detect1(CameraImage image) async {
  //   final faceDetector = GoogleMlKit.vision.faceDetector(
  //     const FaceDetectorOptions(
  //       mode: FaceDetectorMode.accurate,
  //     ),
  //   );
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (final Plane plane in image.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();
  //   final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
  //   final inputImageFormat = InputImageFormatMethods.fromRawValue(image.format.raw) ??
  //       InputImageFormat.YUV_420_888;
  //
  //   final planeData = image.planes.map((Plane plane) {
  //     return InputImagePlaneMetadata(
  //       bytesPerRow: plane.bytesPerRow,
  //       height: plane.height,
  //       width: plane.width,
  //     );
  //   },
  //   ).toList();
  //
  //   final inputImageData = InputImageData(
  //     size: imageSize,
  //     imageRotation: _cameraService.cameraRotation ?? InputImageRotation.Rotation_0deg,
  //     inputImageFormat: inputImageFormat,
  //     planeData: planeData,
  //   );
  //   _faces = await faceDetector.processImage(InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData),);
  // }


  dispose() {
    _faceDetector.close();
  }
}
