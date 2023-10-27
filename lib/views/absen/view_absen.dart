import 'package:sas_hima/constant/const_preference.dart';
import 'package:sas_hima/data/models/employee1.dart';
import 'package:sas_hima/data/models/model_absen_insert.dart';
import 'package:sas_hima/services/Recognition/camera_service.dart';
import 'package:sas_hima/services/Recognition/face_detector.dart';
import 'package:sas_hima/services/Recognition/mlservice.dart';
import 'package:sas_hima/utils/locator.dart';
import 'package:sas_hima/utils/utils_dialog.dart';
import 'package:sas_hima/viewmodels/faceViewmodel.dart';
import 'package:sas_hima/views/absen/view_proteksi_fakegps.dart';
import 'package:sas_hima/views/absen/view_proteksi_lokasi.dart';
import 'package:sas_hima/views/absen/view_succes.dart';
import 'package:sas_hima/views/view_home.dart';
import 'package:sas_hima/widgets/camera_detail.dart';
import 'package:sas_hima/widgets/camera_header.dart';
import 'package:sas_hima/widgets/face_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenView extends StatefulWidget {
  const AbsenView({Key? key}) : super(key: key);

  @override
  State<AbsenView> createState() => _AbsenViewState();
}

class _AbsenViewState extends State<AbsenView> {
  final FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  final CameraService _cameraService = locator<CameraService>();
  final MLService _mlService = locator<MLService>();
  Face? faceDetected;
  String? imagePath;
  Size? imageSize;
  List<int>? bytes;
  String strLatLong = '';
  String strLat = '';
  String strLong = '';
  String strBranch='';
  int intJarakRadius=0;
  bool isMock = false;
  String strAdrress = '';
  String strLatDepo = '';
  String strLatUser = '';
  String strLongDepo = '';
  String strLongUser = '';
  bool _detectingFaces = false;
  bool _initializing = false;
  FaceViewmodel faceViewmodel = FaceViewmodel();

  bool _saving = false;
  late String branchString = '';
  Employee? predictedEmployee;

  @override
  void initState() {
    super.initState();
    _start();
    _getLatLong();
    // checkAndRequestLocationPermission();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _mlService.dispose();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    setState(() => _initializing = false);
    _frameFaces();
  }

  // Future<void> checkAndRequestLocationPermission() async {
  //
  //   if (await Permission.locationWhenInUse.isGranted) {
  //     // Izin lokasi telah diberikan, lakukan tindakan selanjutnya
  //     _getLatLong();
  //   } else if (await Permission.locationWhenInUse.isPermanentlyDenied) {
  //     UtilsDialog.flushBarToastMessage("Izin lokasi ditolak secara permanen. Buka pengaturan untuk mengizinkannya.",context);
  //   } else {
  //     // Tampilkan popup alasan sebelum meminta izin lokasi
  //     bool showRationale = await Permission.locationWhenInUse.shouldShowRequestRationale;
  //     if (showRationale) {
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text("Izin Lokasi"),
  //           content: Text("Aplikasi SAS Mobile membutuhkan izin lokasi untuk menjalankan fitur presensi."),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text("Tidak"),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //             TextButton(
  //               child: Text("Izinkan"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 requestLocationPermission();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     } else {
  //       requestLocationPermission();
  //     }
  //   }
  // }

  // void requestLocationPermission() async{
  //   if (await Permission.locationWhenInUse.isGranted) {
  //     _getLatLong();
  //     UtilsDialog.flushBarToastMessage('Izin lokasi telah diberikan', context);
  //   }else{
  //     var status = await Permission.locationWhenInUse.request();
  //     if (status.isGranted) {
  //       _getLatLong();
  //     } else if (status.isDenied) {
  //       UtilsDialog.flushBarToastMessage("Izin lokasi ditolak. Tidak dapat mengakses lokasi.",context);
  //     } else if (status.isPermanentlyDenied) {
  //       UtilsDialog.flushBarToastMessage(
  //           "Izin lokasi ditolak secara permanen. Buka pengaturan untuk mengizinkannya.",context);
  //     }
  //   }
  // }

  void _getLatLong() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strLatDepo = prefs.getString(ConstPreference.CLAT)!;
    strLongDepo = prefs.getString(ConstPreference.CLONG)!;
    strBranch = prefs.getString(ConstPreference.CBRANCH)!;
    strLatUser = prefs.getString(ConstPreference.CLATPOSITION)!;
    strLongUser = prefs.getString(ConstPreference.CLONGPOSITION)!;
    isMock = prefs.getBool(ConstPreference.CISMOCK)!;
    intJarakRadius = int.parse(prefs.getString(ConstPreference.CJARAKRADIUS)!);
    double dblLatitude = double.parse(strLatUser);
    double dblLongitude = double.parse(strLongUser);
    List<Placemark> placemarks = await placemarkFromCoordinates(dblLatitude, dblLongitude);
    Placemark place = placemarks[0];
    setState(() {
      strLatLong = '$strLatUser,$strLongUser';
      strLat = strLatUser;
      strLong = strLongUser;
      strAdrress = '${place.name}, ${place.locality}, ${place.administrativeArea}';
    });

    if(isMock == true){
      if (mounted) {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: const ProteksiFakeGps(),
                type: PageTransitionType.fade));
      }
      return;
    }
    double distance = calculateDistance(double.parse(strLatDepo), double.parse(strLongDepo), double.parse(strLat), double.parse(strLong));
    if(distance >= intJarakRadius && strBranch != '2000') {
      if (mounted) {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: ProteksiLokasiView(
                  lat: strLat,
                  long: strLong,
                  jarak: '$distance',
                ),
                type: PageTransitionType.fade));
      }
      return;
    }
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters.roundToDouble();
  }

  bool isMorning() {
    var currentTime = DateTime.now().hour;
    return currentTime < 12;
  }

  Future _frameFaces() async {
    imageSize = _cameraService.getImageSize();
    _saving = true;
    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;
        _detectingFaces = true;
        try {
          await _faceDetectorService.detectFacesFromImage(image);
          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() {
              faceDetected = _faceDetectorService.faces[0];
              print('hima faceDetected: $faceDetected');
            });
            if ((faceDetected!.headEulerAngleY! > 10 ||
                faceDetected!.headEulerAngleY! < -10)) {
            } else {
              if (strLat != '' && strLong != '') {
                _mlService.setCurrentPrediction(image, faceDetected);
                var employee = await _predictEmployee();
                print('hima employee: $employee');
                if (employee != null) {
                  _saving = true;
                  XFile? file = await _cameraService.takePicture();
                  String? base64 = await _cameraService.convertBase64(file);
                  if (_saving) {
                    _cameraService.cameraController?.stopImageStream();
                  }
                  predictedEmployee = employee;
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  branchString = prefs.getString(ConstPreference.CBRANCH)!;
                  bool morning = isMorning();
                  var ctipe = morning ? 'I' : 'O';
                  Map<String, dynamic> data = {
                    'cbranch': branchString,
                    'cnik': predictedEmployee!.cNik,
                    'ctipe': ctipe,
                    'clat': strLat,
                    'clong': strLong,
                  };
                  _insertAbsen(data, ctipe, base64!);
                }
              }
            }
          }
          _detectingFaces = false;
        } catch (e) {
          _detectingFaces = false;
        }
      }
    });
  }

  _insertAbsen(Map<String, dynamic> data, String ctipe, String base64) async {
    var result = await faceViewmodel.insertAbsen(data, context);
    insertAbsenModel response = insertAbsenModel.fromJson(result);
    if (mounted) {
      if (response.status != '0') {
        String refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
            SuccessView(
                base64string: base64,
                base64file: '${response.data![0].image}',
                timeString:'${response.data![0].time}',
                dateString: '${response.data![0].date}',
                nameString: '${response.data![0].name}',
                ctipe: ctipe
            )));
        if(refresh == 'refresh'){
          setState(() {
            Navigator.pop(context,"refresh");
          });
        }
      } else {
        Navigator.pop(context,"refresh");
        UtilsDialog.flushBarErrorMessage("Maaf", "${response.pesan}", context);
      }
    }
  }

  Future<Employee?> _predictEmployee() async {
    Employee? nikAndNama = await _mlService.predictEmployee();
    return nikAndNama;
  }

  _onBackPressed() {
    Navigator.of(context).pop();
    setState(() => isMock = false);
  }

  @override
  Widget build(BuildContext context) {
    late Widget body;
    final width = MediaQuery.of(context).size.width;

    if (_initializing) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing) {
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
                height: width * _cameraService.cameraController!.value.aspectRatio,
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
            "Absen Sekarang",
            onBackPressed: _onBackPressed,
            vermuk: true,
          ),
          Positioned(
            bottom: 20,
            child: CameraDetail(strLatLong, strAdrress),
          ),
        ],
      ),
    );
  }
}
