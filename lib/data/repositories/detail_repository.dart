import 'package:sas_hima/constant/const_url.dart';
import 'package:sas_hima/services/network/service_Base_api.dart';
import 'package:sas_hima/services/network/service_network_api.dart';

class DetailRepository{

  final BaseApiService _apiService = NetworkApiService();

  Future<dynamic> getLandingDetailPage(dynamic data) async {
    try{
      dynamic response = await _apiService.getPostApiResponse(ConstUrl.landingPageDetailEndPint, data);
      return response;
    }catch(e){
      rethrow;
    }
  }


}