import 'package:sas_hima/constant/const_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppDataNotFound extends StatelessWidget {
  const AppDataNotFound(this.ket, {Key? key}) : super(key: key);
  final String ket;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        child: Stack(
          children: [

            Positioned(
              width: width,
              bottom: 0,
              child: Lottie.asset(
                lottieNodata,
                fit: BoxFit.cover,
                width: width,
              ),
            ),
            Positioned(
                top: 10,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                        border: const Border(
                          top: BorderSide(width: 1, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                          left: BorderSide(width: 1, color: Colors.grey),
                          right: BorderSide(width: 1, color: Colors.grey),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(ket,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
