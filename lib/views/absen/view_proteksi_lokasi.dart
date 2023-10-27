import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProteksiLokasiView extends StatefulWidget {
  const ProteksiLokasiView({Key? key, required this.jarak, required this.long, required this.lat}) : super(key: key);
  final String jarak;
  final String long;
  final String lat;


  @override
  State<ProteksiLokasiView> createState() => _ProteksiLokasiViewState();
}

class _ProteksiLokasiViewState extends State<ProteksiLokasiView> {

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Lottie.asset(
              lottieRadius,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
                top: 50,
                child: SizedBox(
                    width: width,
                    child: Center(
                        child: Column(
                          children: [
                            Text('DILUAR RADIUS!', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.red),),
                            SizedBox(height: 2,),
                            Text('Jarak dari depo maks. 30m',
                              style: TextStyle(fontSize: 18),),
                          ],
                        )))),
            Positioned(
                bottom: 40,
                child: SizedBox(
                    width: width,
                    child: Center(
                        child: Column(
                          children: [
                            Text('Posisi anda dari depo: ${widget.jarak}m',
                              style: const TextStyle(fontSize: 18),),
                            Text('${widget.lat} , ${widget.long}',
                              style: const TextStyle(fontSize: 18),),
                            const SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: AppButton(color: Colors.blue,
                                  text: 'KEMBALI',
                                  icon: const Icon(Icons.arrow_back,color: Colors.white,),
                                  onPressed: () {
                                    _onBackPressed();
                                  }),
                            )
                          ],
                        )))),
          ],
        ),
      ),
    );
  }
}
