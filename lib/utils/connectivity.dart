import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class Connection  {

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      return true; // Terhubung dengan jaringan seluler atau Wi-Fi
    } else {
      return false; // Tidak terhubung dengan internet
    }
  }

}