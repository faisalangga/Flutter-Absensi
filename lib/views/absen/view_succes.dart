import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/constant/const_preference.dart';
import 'package:sas_hima/utils/utils.dart';
import 'package:sas_hima/views/view_home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessView extends StatefulWidget {
  const SuccessView({
    required this.base64string,
    required this.base64file,
    required this.timeString,
    required this.dateString,
    required this.nameString,
    required this.ctipe,
    Key? key,
  }) : super(key: key);
  final String base64string;
  final String base64file;
  final String timeString;
  final String dateString;
  final String nameString;
  final String ctipe;

  @override
  State<SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> {
  String strLatUser = '';
  String strLongUser = '';

  @override
  void initState() {
    closeScreenAfterDelay();
    _getLatLong();
    super.initState();
  }

  void _getLatLong() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    strLatUser = prefs.getString(ConstPreference.CLATPOSITION)!;
    strLongUser = prefs.getString(ConstPreference.CLONGPOSITION)!;
  }

  void closeScreenAfterDelay() async {
    await Future.delayed(const Duration(seconds: 5));
    goHome();
  }

  void goHome() {
    Navigator.pop(context,'refresh');
  }



  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(widget.base64string);
    Uint8List bytesfile = base64Decode(widget.base64file);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Lottie.asset(
            lottieSuccess,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              top: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      goHome();
                    },
                    child: Container(
                        width: width,
                        alignment: Alignment.topRight,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.close, size: 30),
                        )),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: LottieBuilder.asset(lottieCheck),
                  ),
                  widget.ctipe == 'I'
                      ?  Column(
                          children: [
                            Text('Berhasil Absen Masuk',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Selamat Bekerja!',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      :  Column(
                          children: [
                            Text('Berhasil Absen Pulang',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Hati-hati dijalan!',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ],
              )
          ),
          const SizedBox(
            height: 100,
          ),
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 190,
              height: 130,
              child: Stack(
                children: [
                  ClipOval(
                    child: Image.memory(
                      bytesfile,
                      width: 50 * 2,
                      height: 50 * 2,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ClipOval(
                      child: Image.memory(
                        bytes,
                        width: 50 * 2,
                        height: 50 * 2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                      child: Text(
                        Utils.shortenString(widget.nameString, 17) ,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Text(
                    widget.ctipe == 'I'
                        ? 'Absen Masuk jam'
                        : 'Absen Pulang jam',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    widget.timeString,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  Text(
                    widget.dateString,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
