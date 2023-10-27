import 'dart:math';
import 'dart:typed_data';
import 'package:sas_hima/data/db/database_helper.dart';
import 'package:sas_hima/data/models/employee1.dart';
import 'package:sas_hima/data/models/user.dart';
import 'package:sas_hima/services/Recognition/image_converter.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class MLService {
  Interpreter? _interpreter;
  double threshold = 0.7;

  List _predictedData = [];
  List get predictedData => _predictedData;
  // //
  List _predictedData2 = [];
  List get predictedData2 => _predictedData2;
  //
  List _predictedData3 = [];
  List get predictedData3 => _predictedData3;

  Future initialize() async {
    print('hima mlservice initialize');
    late Delegate delegate;
    try {
      // if (Platform.isAndroid) {
      //   delegate = GpuDelegateV2(
      //     options: GpuDelegateOptionsV2(
      //       isPrecisionLossAllowed: false,
      //       inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
      //       inferencePriority1: TfLiteGpuInferencePriority.minLatency,
      //       inferencePriority2: TfLiteGpuInferencePriority.auto,
      //       inferencePriority3: TfLiteGpuInferencePriority.auto,
      //     ),
      //   );
      // }
      // else if (Platform.isIOS) {
      //   delegate = GpuDelegate(
      //     options: GpuDelegateOptions(
      //         allowPrecisionLoss: true,
      //         waitType: TFLGpuDelegateWaitType.active),
      //   );
      // }
      print('hima interpreter');
      // var interpreterOptions = InterpreterOptions()..addDelegate(GpuDelegate());
      this._interpreter  = await Interpreter.fromAsset('mobilefacenet.tflite');
      print('hima interpreter111 $_interpreter');
    } catch (e) {
      print('Failed to load model.');
      print('Failed $e');
      print(e);
    }
  }

  void setCurrentPrediction(CameraImage cameraImage, Face? face) {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = _preProcess(cameraImage, face);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    this._interpreter?.run(input, output);
    output = output.reshape([192]);
    this._predictedData = List.from(output);
    print('hima _predictedData1 ${this._predictedData}');
  }

  void setCurrentPrediction2(CameraImage cameraImage, Face? face) {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = _preProcess(cameraImage, face);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    this._interpreter?.run(input, output);
    output = output.reshape([192]);
    this._predictedData2 = List.from(output);
    print('hima _predictedData2 ${this._predictedData2}');
  }

  void setCurrentPrediction3(CameraImage cameraImage, Face? face) {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = _preProcess(cameraImage, face);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    this._interpreter?.run(input, output);
    output = output.reshape([192]);
    this._predictedData3 = List.from(output);
    print('hima _predictedData3 ${this._predictedData3}');
  }

  Future<Employee?> predictEmployee() async {
    print("hima predictEmployeeaaa ${_searchResult1(this._predictedData)}");
    return _searchResult1(this._predictedData);
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);
    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  Future<Employee?> _searchResult1(List predictedData) async {
    DatabaseHelper _dbHelper = DatabaseHelper.instance;
    List<Employee> employees = await _dbHelper.queryAllEmployee();
    double minDist = 999;
    double currDist = 0.0;
    double currDist2 = 0.0;
    double currDist3 = 0.0;
    Employee? predictedResult;

    for (Employee u in employees) {
      currDist = _euclideanDistance(u.cFacepoint, predictedData);
      currDist2 = _euclideanDistance(u.cFacepoint2, predictedData);
      currDist3 = _euclideanDistance(u.cFacepoint3, predictedData);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predictedResult = u;
      }else if (currDist2 <= threshold && currDist2 < minDist) {
        minDist = currDist2;
        predictedResult = u;
      }else if (currDist3 <= threshold && currDist3 < minDist) {
        minDist = currDist3;
        predictedResult = u;
      }
    }
    if(predictedResult != null){
      print('hima predictedResult111 ada');
    }else{
      print('hima predictedResult111 null');
    }
    return predictedResult;
  }

  double _euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  void setPredictedData(value) {
    this._predictedData = value;
  }
  void setPredictedData2(value) {
    this._predictedData2 = value;
  }
  void setPredictedData3(value) {
    this._predictedData3 = value;
  }

  dispose() {}
}