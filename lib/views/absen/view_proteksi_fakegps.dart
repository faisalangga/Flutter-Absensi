
import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class ProteksiFakeGps extends StatefulWidget {
  const ProteksiFakeGps({Key? key}) : super(key: key);

  @override
  State<ProteksiFakeGps> createState() => _ProteksiFakeGpsState();
}

class _ProteksiFakeGpsState extends State<ProteksiFakeGps> {

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
              lottieFake,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
                top: 50,
                width: width,
                child: Column(
                  children: [
                    Text('PERINGATAN!', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.red),),
                    SizedBox(height: 2,),
                    Text('Fake GPS Terdeteksi aktif',
                      style: TextStyle(fontSize: 18),),
                  ],
                )),
            Positioned(
                bottom: 30,
                child: SizedBox(
                    width: width,
                    child: Center(
                        child: Column(
                          children: [
                            const Text('Silahkan matikan fake GPS anda!',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold), ),
                            const SizedBox(height: 40,),
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
                        )
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}
