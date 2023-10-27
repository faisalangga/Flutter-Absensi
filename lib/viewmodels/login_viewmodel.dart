import 'package:sas_hima/constant/const_preference.dart';
import 'package:sas_hima/data/models/model_employee.dart';
import 'package:sas_hima/data/models/model_user.dart';
import 'package:sas_hima/data/repositories/login_repository.dart';
import 'package:sas_hima/utils/SessionManager.dart';
import 'package:sas_hima/data/db/database_helper.dart';
import 'package:flutter/material.dart';

class LoginViewModel {
  final _loginRepo = LoginRepository();

  Future<dynamic> loginApi(dynamic data, BuildContext context) async {
    try {
      final value = await _loginRepo.getUser(data);
      UserModel response = UserModel.fromJson(value);
      if (response.status == '1') {
        String cBranch = response.data![0].cBranch.toString();
        String cDesc = response.data![0].cDesc.toString();
        String cLat = response.data![0].cLat.toString();
        String cLong = response.data![0].cLong.toString();
        String jarak_radius = response.data![0].jarak_radius.toString();
        SessionManager().setPreference(ConstPreference.CBRANCH, cBranch);
        SessionManager().setPreference(ConstPreference.CNAMABRANCH, cDesc);
        SessionManager().setPreference(ConstPreference.CLAT, cLat);
        SessionManager().setPreference(ConstPreference.CLONG, cLong);
        SessionManager().setPreference(ConstPreference.ISLOGIN, "1");
        SessionManager().setPreference(ConstPreference.CJARAKRADIUS, jarak_radius);
        Map<String, dynamic> reqEmployee = {
          'cbranch': cBranch,
        };
        getEmployee(reqEmployee, context);
      }
      return value;
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> getEmployee(dynamic data, BuildContext context) async {
    try {
      final value1 = await _loginRepo.getEmployee(data);
      EmployeeModel response1 = EmployeeModel.fromJson(value1);
      if (response1.status == '1') {
        DatabaseHelper databaseHelper = DatabaseHelper.instance;
        List<Map<String, dynamic>> data = [];
        for (int i = 0; i <= (response1.data!.length - 1); i++) {
          Map<String, dynamic> personData = {
            'cBranch': response1.data![i].cbranch,
            'cNik': response1.data![i].cnik,
            'cNama': response1.data![i].cnama,
            'cFacepoint': response1.data![i].cfacepoint,
            'cFacepoint2': response1.data![i].cfacepoint2,
            'cFacepoint3': response1.data![i].cfacepoint3,
          };
          data.add(personData);
        }
        await databaseHelper.insert(data);
      }
      return value1;
    } catch (error) {
      return error;
    }
  }
}
