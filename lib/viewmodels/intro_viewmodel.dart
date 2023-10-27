import 'package:sas_hima/data/repositories/intro_repository.dart';
import 'package:flutter/material.dart';

class IntroViewodel {
  final _introRepo = IntroRepository();

  Future<dynamic> mappingDeviceApi(dynamic data, BuildContext context) async {
    try{
      final value = await _introRepo.mappingDeviceApi(data);
      return value;
    }catch(error){
      return error;
    }
  }
}