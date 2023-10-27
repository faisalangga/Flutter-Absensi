import 'package:sas_hima/constant/const_url.dart';
import 'package:sas_hima/services/network/service_Base_api.dart';
import 'package:sas_hima/services/network/service_network_api.dart';

class FaceRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<dynamic> insertApi(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.getPostApiResponse(
          ConstUrl.registerFaceEndPint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getNik(Map<String, dynamic> data) async {
    try {
      dynamic response =
          await _apiService.getPostApiResponse(ConstUrl.getnikEndPint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> insertAbsen(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.getPostApiResponse(
          ConstUrl.absensiFaceEndPint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getEmployee(Map<String, dynamic> data) async  {
    try {
      dynamic response = await _apiService.getPostApiResponse(
          ConstUrl.getEmployeeEndPint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
