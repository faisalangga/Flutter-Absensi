import 'package:sas_hima/constant/const_preference.dart';
import 'package:sas_hima/utils/SessionManager.dart';
import 'package:sas_hima/views/view_home.dart';
import 'package:sas_hima/views/view_intro.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashService {
  Future<String?> isLogin() => SessionManager().getPreference(ConstPreference.ISLOGIN);

  void checkAuthentication(BuildContext context) async {
    isLogin().then((value) {
      if (value.toString() == '' || value.toString() == 'null') {
        Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: const IntroView(),
                reverseDuration: const Duration(milliseconds: 2000),
                duration: const Duration(milliseconds: 2000),
                type: PageTransitionType.fade));
      } else {
        Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: const HomeView(),
                reverseDuration: const Duration(milliseconds: 2000),
                duration: const Duration(milliseconds: 2000),
                type: PageTransitionType.fade));
      }
    });
  }
}
