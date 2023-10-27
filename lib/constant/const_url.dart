class ConstUrl{
  static var baseUrl = 'http://192.168.100.29:5000/fingerApp' ;
  // static var baseUrl = 'http://apimobile.sentralsari.com:5000/fingerApp'; //ip: 192.168.100.18:5001
  static var baseUrlGolang = 'http://api.sentralsari.com:5000' ;

  static var loginEndPint                     =  '$baseUrl/login' ;
  static var getEmployeeEndPint               =  '$baseUrl/employees/get' ;
  static var registerFaceEndPint              =  '$baseUrl/employees/insert';
  static var absensiFaceEndPint               =  '$baseUrl/absensi/insert';
  static var landingPageEndPint               =  '$baseUrl/landing-page';
  static var getnikEndPint                    =  '$baseUrlGolang/getnikhris' ;
  static var landingPageDetailEndPint         =  '$baseUrl/landing-page-detail' ;
  static var mappingDeviceEndPint             =  '$baseUrl/cek_device' ;
  static var versionEndPint                   =  '$baseUrl/get-version' ;

}