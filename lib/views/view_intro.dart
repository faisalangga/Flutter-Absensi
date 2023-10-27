import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/data/models/model_intro.dart';
import 'package:sas_hima/utils/connectivity.dart';
import 'package:sas_hima/utils/utils_dialog.dart';
import 'package:sas_hima/viewmodels/intro_viewmodel.dart';
import 'package:sas_hima/views/view_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../constant/const_preference.dart';
import '../utils/SessionManager.dart';

class IntroView extends StatefulWidget {
  const IntroView({Key? key}) : super(key: key);

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  var identifier = '';
  var _udid = "";

  final Connection connection = Connection();
  IntroViewodel introViewodel = IntroViewodel();

  @override
  void initState() {
    super.initState();
    getDevice();
    initPlatformState();
  }


  Future<void> getDevice() async {
    String identifier1;
    try {
      identifier1 = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      identifier1 = 'Gagal mengambil id perangkat';
    }
    if (!mounted) return;
    setState(() {
      identifier = identifier1;
    });
  }

  Future<void> initPlatformState() async {
    String udid;
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }

    if (!mounted) return;

    setState(() {
      _udid = udid;
    });
  }

  Future<void> salin() async {
    Clipboard.setData(ClipboardData(text: identifier.toUpperCase()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Id perangkat disalin'),
      ),
    );
  }

  Future<void> getApi() async {
    UtilsDialog.loading(context, 'Mohon tunggu..');
    bool isConnected = await connection.checkInternetConnectivity();
    if (isConnected) {
      Map<String, dynamic> data = {'deviceid': identifier.toUpperCase()};
      if (mounted) {
        var result = await introViewodel.mappingDeviceApi(data, context);
        IntroModel response = IntroModel.fromJson(result);
        if (response.status == '1') {
          if (mounted) {
            Navigator.pop(context);
            SessionManager().setPreference(
                ConstPreference.CBRANCH, response.pesan.toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginView(),
              ),
            );
          }
        } else {
          if (mounted) {
            Navigator.pop(context);
            UtilsDialog.flushBarErrorMessage(
                'Maaf!', '${response.pesan}', context);
          }
        }
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
        UtilsDialog.flushBarErrorMessage(
            'Tidak ada koneksi', 'Periksa Internet anda', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          width: width,
                          child: SizedBox(
                            width: width * 0.3,
                            child: Image.asset(logoImage),
                          ),
                        ),
                        Text('Selamat datang,',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: width / 15)),
                        SizedBox(
                            height: height * 0.45,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width,
                                  height: height * 0.45,
                                  child: Image.asset(imgWelcome),
                                ),
                              ],
                            )),
                        SizedBox(
                            height: height / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                    'Pastikan Kode perangkat anda sudah terdaftar'),
                                const SizedBox(
                                  height: 10,
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    width: width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.phone_iphone,
                                              size: 50),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'ID Perangkat',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(_udid.toUpperCase()),
                                              // Text(identifier.toUpperCase()),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              salin();
                                            },
                                            child: Container(
                                              width: width * 0.15,
                                              height: width * 0.15,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.copy,
                                                        color: Colors.white,
                                                        size: width * 0.06),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text('Salin',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                width / 35)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    getApi();
                  },
                  child: Container(
                    width: width,
                    color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Silahkan Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
