
import 'package:sas_hima/constant/const_url.dart';
import 'package:sas_hima/services/network/service_Base_api.dart';
import 'package:sas_hima/services/network/service_network_api.dart';

class HomeRepository{

  final BaseApiService _apiService = NetworkApiService();

  Future<dynamic> getLandingPage(dynamic data) async {
    try{
      dynamic response = await _apiService.getPostApiResponse(ConstUrl.landingPageEndPint, data);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> getCekVersi(dynamic data) async {
    try{
      dynamic response = await _apiService.getPostApiResponse(ConstUrl.versionEndPint, data);
      return response;
    }catch(e){
      rethrow;
    }
  }


}