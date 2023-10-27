import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class UtilsDate {

  static Future<String> formatJamNTP() async {
    DateTime ntpTime = await NTP.now();
    return DateFormat('hh:mm:ss').format(ntpTime);
  }

  static String formatJam(){
    DateTime dateTime = DateTime.now() ;
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  static String formatHari(hari, tanggal) {
    // DateTime dateTime = DateTime.now() ;
    // var hari = DateFormat('EEEE').format(dateTime);
    // var tanggal = DateFormat('dd MMMM yyyy').format(dateTime);
    if(hari == 'Monday'){
      hari = 'Senin';
    }else if(hari == 'Tuesday'){
      hari = 'Selasa';
    }else if(hari == 'Wednesday'){
      hari = 'Rabu';
    }else if(hari == 'Thursday'){
      hari = 'Kamis';
    } else if(hari == 'Friday'){
      hari = 'Jumat';
    } else if(hari == 'Saturday'){
      hari = 'Sabtu';
    } else if(hari == 'Sunday'){
      hari = 'Minggu';
    }
    return '$hari, $tanggal';
  }

}