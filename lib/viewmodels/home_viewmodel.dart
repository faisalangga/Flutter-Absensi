
import 'package:sas_hima/data/repositories/home_repository.dart';
import 'package:flutter/material.dart';

class HomeViewmodel {
  final _homeRepo = HomeRepository();

  Future<dynamic> getlandingPage(dynamic data, BuildContext context) async {
    try {
      final value = await _homeRepo.getLandingPage(data);
      return value;
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> getCekVersi(dynamic data, BuildContext context) async {
    try {
      final value = await _homeRepo.getCekVersi(data);
      return value;
    } catch (error) {
      return error;
    }
  }
}