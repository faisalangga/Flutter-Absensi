
import 'package:sas_hima/data/repositories/face_repository.dart';
import 'package:flutter/material.dart';

class FaceViewmodel {

  final _faceRepo = FaceRepository();

  insertFace(dynamic data, BuildContext context)async{
    try {
      final value = await _faceRepo.insertApi(data);
      return value;
    }catch (error) {
      return error;
    }
  }

  getNik(dynamic data, BuildContext context) async {
    try {
      final value = await _faceRepo.getNik(data);
      return value;
    }catch (error) {
      return error;
    }
  }

  insertAbsen(dynamic data, BuildContext context)async{
    try {
      final value = await _faceRepo.insertAbsen(data);
      return value;
    }catch (error) {
      return error;
    }
  }

}