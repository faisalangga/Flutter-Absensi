import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class UtilsDialog {

  static loading(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 25, right: 25),
                            child: const CircularProgressIndicator(backgroundColor: Colors.blue),
                          ),
                          Text(text, style: const TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600))
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void flushBarToastMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.all(15),
          // title: message,
          message: message,
          duration: const Duration(seconds: 2),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.BOTTOM,
          backgroundColor: Colors.black,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          icon: const Icon(
            Icons.error,
            size: 28,
            color: Colors.white,
          ),
        )..show(context));
  }

  static void flushBarErrorMessage(String title,String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(15),
          title: title,
          message: message,
          duration: const Duration(seconds: 3),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.BOTTOM,
          backgroundColor: Colors.red,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          icon: const Icon(
            Icons.error,
            size: 28,
            color: Colors.white,
          ),
        )..show(context));
  }

  static void flushBarSuccesMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          forwardAnimationCurve: Curves.decelerate,
          padding: const EdgeInsets.all(15),
          title: 'Berhasil',
          message: message,
          duration: const Duration(seconds: 4),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.BOTTOM,
          backgroundColor: Colors.green,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          icon: const Icon(
            Icons.check_circle,
            size: 28,
            color: Colors.white,
          ),
        )..show(context));
  }
}