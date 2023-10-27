
import 'package:sas_hima/data/repositories/detail_repository.dart';
import 'package:flutter/material.dart';

class DetailViewmodel {
  final _detailRepo = DetailRepository();

  Future<dynamic> getLandingDetailPage(dynamic data, BuildContext context) async {
    try {
      print('hima data $data');
      final value = await _detailRepo.getLandingDetailPage(data);
      print('hima value $value');
      return value;
    } catch (error) {
      return error;
    }
  }
}
