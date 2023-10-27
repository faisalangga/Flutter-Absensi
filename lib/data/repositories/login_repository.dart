
import 'package:sas_hima/constant/const_url.dart';
import 'package:sas_hima/services/network/service_Base_api.dart';
import 'package:sas_hima/services/network/service_network_api.dart';

class LoginRepository{
  final BaseApiService _apiService = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    try{
      dynamic response = await _apiService.getPostApiResponse(ConstUrl.loginEndPint, data);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> getUser(Map<String, dynamic> data1) async{
    try{
      dynamic response = await _apiService.getPostApiResponse(ConstUrl.loginEndPint, data1);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> getEmployee(Map<String, dynamic> data)async {
    try{
      dynamic response = await _apiService.getPostApiResponse(ConstUrl.getEmployeeEndPint, data);
      return response;
    }catch(e){
      rethrow;
    }
  }
}