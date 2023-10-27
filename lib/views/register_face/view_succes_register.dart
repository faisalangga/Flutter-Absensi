import 'dart:convert';
import 'dart:typed_data';

import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/services/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccesRegister extends StatefulWidget {
  const SuccesRegister(
      {Key? key,
      required this.base64String,
      required this.namaString,
      required this.nikString})
      : super(key: key);
  final String base64String;
  final String namaString;
  final String nikString;

  @override
  State<SuccesRegister> createState() => _SuccesRegisterState();
}

class _SuccesRegisterState extends State<SuccesRegister> {

  @override
  void initState() {
    closeScreenAfterDelay();
    super.initState();
  }

  void closeScreenAfterDelay() async {
    await Future.delayed(const Duration(seconds: 5));
    goHome();
  }

  void goHome() async {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context,'refresh');
    // Navigator.of(context).popUntil(ModalRoute.withName(RoutesName.home));
    // Navigator.of(context).popUntil(ModalRoute.withName(RoutesName.home));
    // Navigator.pop(
    //   context,
    //   PageRouteBuilder(
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       var begin = const Offset(0.0, -1.0);
    //       var end = Offset.zero;
    //       var curve = Curves.ease;
    //       var tween =
    //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //       return SlideTransition(
    //         position: animation.drive(tween),
    //         child: child,
    //       );
    //     },
    //     pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(widget.base64String);
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
              top: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  goHome();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.close, size: 30),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: LottieBuilder.asset(lottieCheck),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Terima kasih',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Wajah anda berhasil didaftarkan',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.all(20),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.memory(
                                bytes,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NIK : ${widget.nikString}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.namaString.length >= 17
                                      ? 'Nama : ${widget.namaString.substring(0, 17)}...'
                                      : widget.namaString,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
