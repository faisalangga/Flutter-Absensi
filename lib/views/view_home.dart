import 'dart:async';
import 'dart:ffi';
import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/constant/const_preference.dart';
import 'package:sas_hima/constant/const_string.dart';
import 'package:sas_hima/data/db/database_helper.dart';
import 'package:sas_hima/data/models/model_insert.dart';
import 'package:sas_hima/data/models/model_landing.dart';
import 'package:sas_hima/data/models/model_version.dart';
import 'package:sas_hima/services/Recognition/camera_service.dart';
import 'package:sas_hima/services/Recognition/face_detector.dart';
import 'package:sas_hima/services/Recognition/mlservice.dart';
import 'package:sas_hima/services/routes/routes_name.dart';
import 'package:sas_hima/utils/connectivity.dart';
import 'package:sas_hima/utils/locator.dart';
import 'package:sas_hima/utils/utils_date.dart';
import 'package:sas_hima/utils/utils_dialog.dart';
import 'package:sas_hima/viewmodels/home_viewmodel.dart';
import 'package:sas_hima/viewmodels/login_viewmodel.dart';
import 'package:sas_hima/views/absen/view_absen.dart';
import 'package:sas_hima/views/detail/view_detail_absen.dart';
import 'package:sas_hima/views/register_face/view_register_face1.dart';
import 'package:sas_hima/views/view_login.dart';
import 'package:sas_hima/widgets/app_button.dart';
import 'package:sas_hima/widgets/card_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/SessionManager.dart';

class HomeView extends StatefulWidget {
  final String? lat;
  final String? long;

  const HomeView( {Key? key, this.lat, this.long, }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isRefresh = false;
  late String timeString = '';
  late String hariString='';
  late String namaString = '';
  late String namaBranchString = '';
  late String branchString = '';
  late String nikString = '';
  late String positionLat = '';
  late String positionLong = '';
  late String latString = '';
  late String longString = '';
  late String versionString = '';
  late String codeVersionString = '';
  late String ttlEmployeeString = '0';
  late String ttlMasukString = '0';
  late String ttlKeluarString = '0';
  late String ttlNeedApprove = '0';
  late String csasradius = '0';
  late double latitude = 0.0;
  late double longitude = 0.0;
  bool isPermissionLocation = false;
  String address = '';
  bool ismock = false;
  bool isCekVersion = false;
  bool isPeriodic = true;
  bool isResetPeriodic = true;
  bool isNeedApproved = false;
  LoginViewModel loginViewmodel = LoginViewModel();
  HomeViewmodel homeViewmodel = HomeViewmodel();
  final MLService _mlService = locator<MLService>();
  bool isLoading = true;
  final FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  final CameraService _cameraService = locator<CameraService>();
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  var locationOptions;
  late StreamController<Position> _positionStreamController;
  late Stream<Position> positionStream;

  String strLatUser = '';
  String strLongUser = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _getFromSharedPreferences();
    _landingPage();
    _initializeServices();
    _getCurrentTime();
     // hariString = UtilsDate.formatHari();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
    _start();
  }


  void _start() {
    _positionStreamController = StreamController<Position>();
    positionStream = _positionStreamController.stream;
    if (isPermissionLocation) {
      initializePositionStream();
      setState(() {
        isPermissionLocation = false;
      });
    }else{
      checkAndRequestLocationPermission();
    }
  }

  _reload() {
    _start();
  }

  //hasil position
  Future<void> initializePositionStream() async {

    try {
      Stream<Position> stream = await checkAndGetPositionStream();
      stream.listen((position) {
        _positionStreamController.add(position);
      });
    } catch (error) {
      _positionStreamController.addError(error);
    }
  }

  Stream<Position> getPositionStream() {
    const locationOptions = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    return Geolocator.getPositionStream(locationSettings: locationOptions);
  }

  Future<void> checkAndRequestLocationPermission() async {
    if (await Permission.locationWhenInUse.isGranted) {
      initializePositionStream();
    } else if (await Permission.locationWhenInUse.isPermanentlyDenied) {
      if (mounted) {
        UtilsDialog.flushBarToastMessage(
            "Izin lokasi ditolak secara permanen. Buka pengaturan untuk mengizinkannya.",
            context);
      }
    } else {
      if (!isPermissionLocation) {
        if (mounted) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Izin Lokasi Diperlukan"),
                  content: const Text(
                    appDescIzinLokasi,
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Izinkan"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _requestLocationPermission();
                      },
                    ),
                  ],
                );
              });
        }
      }
      // Tampilkan popup alasan sebelum meminta izin lokasi
    }
  }

  void _requestLocationPermission() async {
    final permissionStatus = await Permission.locationWhenInUse.request();
    if (permissionStatus.isGranted) {
      setState(() {
        isPermissionLocation = true;
      });
      _reload();
    } else if (permissionStatus.isDenied) {
      // Izin ditolak oleh pengguna
      if (mounted) {
        UtilsDialog.flushBarToastMessage(
            "Izin Lokasi ditolak. Izinkan lokasi anda untuk mengaktifkan lokasi anda",
            context);
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      if (mounted) {
        UtilsDialog.flushBarToastMessage(
            "Izin lokasi ditolak secara permanen. Buka pengaturan untuk mengizinkannya.",
            context);
      }
    }
  }

  Future<Stream<Position>> checkAndGetPositionStream() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Lokasi service tidak diaftifkan');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever, we cannot access');
    }
    return getPositionStream();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initializeServices() async {
    await _cameraService.initialize();
    await _mlService.initialize();
    _mlKitService.initialize();
  }


  void _getCurrentTime() async {
    DateTime ntpTime = await NTP.now();
    String hari,tanggal;
    setState(() {
      timeString = DateFormat('HH:mm:ss').format(ntpTime);
      hari = DateFormat('EEEE').format(ntpTime);
      tanggal = DateFormat('dd MMMM yyyy').format(ntpTime);
      hariString = UtilsDate.formatHari(hari,tanggal);
    });
    serviceDaily(ntpTime);
  }



  void serviceDaily(DateTime ntpTime) {
    //reset periodic
    DateTime resetPeriodic =
        DateTime(ntpTime.year, ntpTime.month, ntpTime.day, 01, 0, 0);
    if (ntpTime.isAfter(resetPeriodic) ||
        ntpTime.isAtSameMomentAs(resetPeriodic)) {
      if (isResetPeriodic) {
        isPeriodic = true;
        isResetPeriodic = false;
      }
    }
    if (isPeriodic) {
      DateTime endTime = DateTime(
        ntpTime.year,
        ntpTime.month,
        ntpTime.day,
        19,
        0,
        0,
      );
      DateTime targetTime = DateTime(
        ntpTime.year,
        ntpTime.month,
        ntpTime.day,
        15,
        0,
        0,
      );
      if (ntpTime.isAfter(targetTime) && ntpTime.isBefore(endTime) ||
          ntpTime.isAtSameMomentAs(targetTime)) {
        isCekVersion = true;
        if (isCekVersion) {
          isPeriodic = false;
          isCekVersion = false;
          cekVersi();
        }
      } else {
        isPeriodic = true;
      }
    }
  }

  void cekVersi() async {
    Map<String, dynamic> data = {
      'cbranch': branchString,
    };
    var result = await homeViewmodel.getCekVersi(data, context);
    VersionModel response = VersionModel.fromJson(result);
    if (response.status == "1") {
      if (response.data![0].cversion != _packageInfo.buildNumber) {
        if (mounted) {
          dialogVersi(context);
        }
      }
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  bool isMorning() {
    int currentTime = 0;
    if (timeString.isNotEmpty) {
      List<String> parts = timeString.split(':');
      if (parts.isNotEmpty) {
        String hourString = parts[0];
        currentTime = int.parse(hourString);
      }
      return currentTime < 12;
    } else {
      return false;
    }
  }

  void _getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namaBranchString = prefs.getString(ConstPreference.CNAMABRANCH)!;
      branchString = prefs.getString(ConstPreference.CBRANCH)!;
      latString = prefs.getString(ConstPreference.CLAT)!;
      longString = prefs.getString(ConstPreference.CLONG)!;
      versionString = prefs.getString(ConstPreference.CVERSION)!;
      codeVersionString = prefs.getString(ConstPreference.CCODEVERSION)!;
    });
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    prefs.remove(ConstPreference.CNAMABRANCH);
    prefs.remove(ConstPreference.CLAT);
    prefs.remove(ConstPreference.CLONG);
    prefs.remove(ConstPreference.ISLOGIN);
    prefs.remove(ConstPreference.TOKEN);
    prefs.remove(ConstPreference.CNAMA);
    prefs.remove(ConstPreference.CNIK);
    prefs.remove(ConstPreference.DLASTLOGIN);
    prefs.remove(ConstPreference.CVERSION);
    prefs.remove(ConstPreference.CCODEVERSION);
    prefs.remove(ConstPreference.CJARAKRADIUS);
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteAll();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginView()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _sync(BuildContext context) async {
    Map<String, dynamic> data = {
      'cbranch': branchString,
    };
    var result = await loginViewmodel.getEmployee(data, context);
    InsertModel response = InsertModel.fromJson(result);
    if (mounted) {
      if (response.status == "1") {
        Navigator.pop(context);
        UtilsDialog.flushBarSuccesMessage(
            'Proses sinkronisasi berhasil', context);
        _landingPage();
      } else {
        Navigator.pop(context);
        UtilsDialog.flushBarErrorMessage(
            'Tidak ada data yang disinkronisasikan',
            'Silahkan Diapprove dahulu',
            context);
      }
    }
  }

  void _getAddress() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    address = '${place.name}, ${place.locality}, ${place.administrativeArea}';
  }

  void refreshPage(){
    if(isRefresh == true){
      print('hima isRefresh332 $isRefresh');
      UtilsDialog.loading(context, 'refresh');
      _landingPage();

    }
  }
  void _landingPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchString = prefs.getString(ConstPreference.CBRANCH)!;
    Map<String, dynamic> data = {
      'cbranch': branchString,
    };
    if (mounted) {
      var result = await homeViewmodel.getlandingPage(data, context);
      LandingModel response = LandingModel.fromJson(result);
      if (response.status == '1') {
        setState(() {
          if(isRefresh == true){
            Navigator.pop(context);
          }
          isLoading = false;
          ttlEmployeeString = response.data![0].jmlPegawai!;
          ttlMasukString = response.data![0].totalHadir!.toString();
          ttlKeluarString = response.data![0].totalKeluar!.toString();
          ttlNeedApprove = response.data![0].needapprove!.toString();
          csasradius = response.data![0].csasradius!.toString();
          SessionManager userPreference = SessionManager();
          userPreference.setPreference(
              ConstPreference.CJARAKRADIUS, csasradius);
          if (ttlNeedApprove != '0') {
            isNeedApproved = true;
          } else {
            isNeedApproved = false;
          }
        });
      } else {
        isLoading = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Connection connection = Connection();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool morning = isMorning();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5, right: 10),
                        child: Icon(Icons.home_filled,
                            color: Colors.white, size: 40),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Nama Depo',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              namaBranchString,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, top: 10),
                        child: GestureDetector(
                          onTap: () async {
                            bool isConnected =
                                await connection.checkInternetConnectivity();
                            if (mounted) {
                              if (isConnected) {
                                UtilsDialog.loading(context, 'Sinkronisasi');
                                _sync(context);
                              } else {
                                UtilsDialog.flushBarErrorMessage(
                                    'Tidak ada Internet',
                                    'Tolong cek koneksi internet anda',
                                    context);
                              }
                            }
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.sync,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                'Sync',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            _logout(context);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.login_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                'Keluar',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: width,
                  decoration: const BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Column(
                    children: [
                      isNeedApproved
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: LottieBuilder.asset(lottieNotif),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Ada $ttlNeedApprove orang yang belum diapprove',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        width: width,
                        height: height,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                hariString,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              timeString == ''
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      timeString,
                                      style: const TextStyle(
                                        fontSize: 60,
                                      ),
                                    ),
                              // CircularProgressIndicator(),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      border: const Border(
                                        top: BorderSide(
                                            width: 1, color: Colors.grey),
                                        bottom: BorderSide(
                                            width: 1, color: Colors.grey),
                                        left: BorderSide(
                                            width: 1, color: Colors.grey),
                                        right: BorderSide(
                                            width: 1, color: Colors.grey),
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Status Absen : ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          morning
                                              ? 'ABSEN MASUK'
                                              : 'ABSEN PULANG',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                               Padding(
                                padding: EdgeInsets.only(
                                    left: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Lokasi terdeteksi :',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              location(context),


                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Rekap Absen Hari ini :',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppCardDashboard(
                                          icon: employee,
                                          labelText: 'Karyawan',
                                          value: ttlEmployeeString,
                                          color: Colors.red),
                                      InkWell(
                                        onTap: ()  {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  DetailAbsenView(ctipe: "I")));
                                        },
                                        child: AppCardDashboard(
                                            icon: hadir1,
                                            labelText: isRefresh == true ? 'Refresh' : 'Hadir',
                                            value: ttlMasukString,
                                            color: Colors.cyan),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DetailAbsenView(
                                                ctipe: "O",
                                              ),
                                            ),
                                          );
                                        },
                                        child: AppCardDashboard(
                                            icon: hadir,
                                            labelText: 'Pulang',
                                            value: ttlKeluarString,
                                            color: Colors.cyan),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (latitude != 0.0 && longitude != 0.0) {
                        String refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  AbsenView()));
                        if(refresh == 'refresh'){
                          setState(() {
                            isRefresh = true;
                            refreshPage();
                          });
                        }
                      } else {
                        UtilsDialog.flushBarErrorMessage(
                            'Lokasi belum terdeteksi', 'Mohon tunggu', context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue, // Warna stroke
                          width: 5.0, // Lebar stroke
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black, // Warna stroke
                              width: 3.0, // Lebar stroke
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(lottiescanface3,
                                  fit: BoxFit.contain,
                                  width: 40,
                                  height: 40),
                              const SizedBox(
                                height: 2,
                              ),
                              const Text(
                                'Absen',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Wajah belum terdaftar? silahkan '),
                        GestureDetector(
                            onTap: () {
                              _showBottomSheet(context);
                            },
                            child: const Text(
                              'daftar',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  dialogVersi(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              child: SizedBox(
            height: 350,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Versi Baru Tersedia',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 370,
                      height: 200,
                      child: Image.asset(imgUpdate),
                    ),
                  ),
                  const Text('Silahkan perbarui aplikasi ke versi terbaru'),
                ],
              ),
            ),
          ));
        });
  }

  location(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<Position>(
        stream: positionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Text('No data available');
          }
          latitude = snapshot.data!.latitude;
          longitude = snapshot.data!.longitude;
          ismock = snapshot.data!.isMocked;
          _getAddress();
          SessionManager locPref = SessionManager();
          locPref.setPreference(ConstPreference.CLATPOSITION, '$latitude');
          locPref.setPreference(ConstPreference.CLONGPOSITION, '$longitude');
          locPref.setBool(ConstPreference.CISMOCK, ismock);

          return  Container(
            width: width,
            padding:
            const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text('$latitude $longitude',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text('Pastikan Jangan memakai',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black, // Warna stroke
                                width: 2.0, // Lebar stroke
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                cap,
                                width: 40,
                                height: 40,
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text('Topi')
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black, // Warna stroke
                                width: 2.0, // Lebar stroke
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                masker,
                                width: 40,
                                height: 40,
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text('Masker')
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black, // Warna stroke
                                width: 2.0, // Lebar stroke
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                glasses,
                                width: 40,
                                height: 40,
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text('Kacamata')
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  color: Colors.blue,
                  text: 'Mulai Sekarang',
                  onPressed: () async {
                    Navigator.pop(context);
                    String refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  RegisterFaceView1()));
                    if(refresh == 'refresh'){
                      setState(() {
                        print('hima refresh: $refresh');
                        isRefresh = true;
                        print('hima isRefresh: $isRefresh');
                        refreshPage();
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.start,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class Skelton extends StatelessWidget {
  const Skelton({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}
