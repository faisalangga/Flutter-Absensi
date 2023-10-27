import 'package:sas_hima/constant/const_url.dart';
import 'package:sas_hima/services/network/service_Base_api.dart';
import 'package:sas_hima/services/network/service_network_api.dart';

class IntroRepository{
  final BaseApiService _apiService = NetworkApiService();

  Future<dynamic> mappingDeviceApi(dynamic data) async {
    try{
      dynamic response = await _apiService.getPostApiResponse(ConstUrl.mappingDeviceEndPint, data);
      return response;
    }catch(e){
      rethrow;
    }
  }
}