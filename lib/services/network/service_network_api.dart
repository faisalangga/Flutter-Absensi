import 'dart:convert';
import 'dart:io';
import 'package:sas_hima/data/remote/AppException.dart';
import 'package:sas_hima/services/network/service_Base_api.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiService {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final headers = {
        'Content-Type': 'application/json',
      };
      final jsonRequest = json.encode(data);
      Response response = await post(Uri.parse(url), headers: headers, body: jsonRequest).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiBearerResponse(String url, dynamic data, String token) async {
    dynamic responseJson;
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final jsonRequest = json.encode(data);
      Response response =
      await http.post(Uri.parse(url), headers: headers, body: jsonRequest).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        return jsonDecode(response.body);
      //throw BadRequestException(response.body.toString());
      case 500:
      case 404:
      case 409:
        return jsonDecode(response.body);
        //throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error accured while communicating with server with status code ${response.statusCode}');
    }
  }
}