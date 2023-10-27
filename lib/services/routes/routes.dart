import 'package:sas_hima/services/routes/routes_name.dart';
import 'package:sas_hima/views/absen/view_absen.dart';
import 'package:sas_hima/views/absen/view_proteksi_lokasi.dart';
import 'package:sas_hima/views/detail/view_detail_absen.dart';
import 'package:sas_hima/views/register_face/view_register_face1.dart';
import 'package:sas_hima/views/view_home.dart';
import 'package:sas_hima/views/view_login.dart';
import 'package:flutter/material.dart';

class Routes{

  static Route<dynamic>  generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => const HomeView());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => const LoginView());
      case RoutesName.regmuk1:
        return MaterialPageRoute(builder: (BuildContext context) => const RegisterFaceView1());
      case RoutesName.absen:
        return MaterialPageRoute(builder: (BuildContext context) => const AbsenView());
      default:
        return MaterialPageRoute(builder: (_){
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}