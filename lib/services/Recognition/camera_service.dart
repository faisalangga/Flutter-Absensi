import 'dart:convert';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class CameraService {
  CameraController? _cameraController;
  CameraController? get cameraController => this._cameraController;

  InputImageRotation? _cameraRotation;
  InputImageRotation? get cameraRotation => this._cameraRotation;

  String? _imagePath;
  String? get imagePath => this._imagePath;

  String? _base64Image;
  String? get base64Image => this._base64Image;

  String? _mimeType;
  String? get mimeType => this._mimeType;


  Future<void> initialize() async {
    print('hima camera service initialize');
    if (_cameraController != null) return;
    CameraDescription description = await _getCameraDescription();
    await _setupCameraController(description: description);
    this._cameraRotation = rotationIntToImageRotation(description.sensorOrientation,);
  }

  Future<CameraDescription> _getCameraDescription() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras.firstWhere((CameraDescription camera) =>
    camera.lensDirection == CameraLensDirection.front);
  }

  Future _setupCameraController({
    required CameraDescription description,
  }) async {
    this._cameraController = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController?.initialize();
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<XFile?> takePicture() async {
    assert(_cameraController != null, 'Camera controller not initialized');
    await _cameraController?.stopImageStream();
    XFile? file = await _cameraController?.takePicture();
    _imagePath = file?.path;
    return file;
  }

  Future<String?> convertBase64(XFile? file) async {
    List<int> imageBytes = await file!.readAsBytes();
    _base64Image = base64Encode(imageBytes);
    return _base64Image;
  }

  Future<String?> getMime(XFile? file) async {
    String? imagePath = file?.path;
    _mimeType = lookupMimeType(extension(imagePath!));
    return _mimeType;
  }

  Size getImageSize() {
    assert(_cameraController != null, 'Camera controller not initialized');
    assert(
    _cameraController!.value.previewSize != null, 'Preview size is null');
    return Size(
      _cameraController!.value.previewSize!.height,
      _cameraController!.value.previewSize!.width,
    );
  }

  dispose() async {
    await this._cameraController?.dispose();
    this._cameraController = null;
  }
}