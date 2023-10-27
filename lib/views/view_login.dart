import 'dart:io';

import 'package:sas_hima/data/models/model_user.dart';
import 'package:sas_hima/services/routes/routes_name.dart';
import 'package:sas_hima/utils/connectivity.dart';
import 'package:sas_hima/utils/utils_dialog.dart';
import 'package:sas_hima/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/const_image.dart';
import '../constant/const_preference.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Duration get loginTime => const Duration(milliseconds: 2250);
  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();
  late String branchString;

  @override
  void initState() {
    super.initState();
    _getFromSharedPreferences();
  }

  Future<bool> onBackPressed() async {
    newTime = DateTime.now();
    int difference = newTime.difference(oldTime).inMilliseconds;
    oldTime = newTime;
    if (difference < 1000) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return true;
    } else {
      UtilsDialog.flushBarToastMessage("Tap sekali lagi untuk keluar", context);
      return false;
    }
  }



  void _getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      branchString = prefs.getString(ConstPreference.CBRANCH)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Connection connection = Connection();
    LoginViewModel loginViewModel = LoginViewModel();
    return Scaffold(
      body: Stack(
        children: [
          FlutterLogin(
            logo: const AssetImage(logoImage),
            userType: LoginUserType.name,
            messages: LoginMessages(
                userHint: 'Kode Cabang',
                passwordHint: 'Kata Sandi',
                loginButton: 'Masuk',
                signupButton: 'Daftar',
                forgotPasswordButton: 'Lupa Password?',
                flushbarTitleError: 'Terjadi kesalahan',
                recoverPasswordIntro: 'Set ulang password anda disini',
                recoverPasswordButton: 'Kirim',
                recoverPasswordSuccess: 'Fitur Dalam pengembangan',
                recoverPasswordDescription:
                    'Kami akan mengirim reset password ke email anda',
                goBackButton: 'Kembali'),
            theme: LoginTheme(
              primaryColor: Colors.blue,
              accentColor: Colors.cyan,
              errorColor: Colors.red,
              pageColorLight: Colors.white,
              bodyStyle: const TextStyle(
                fontSize: 16,
              ),
              textFieldStyle: const TextStyle(
                color: Colors.black,
              ),
              cardTheme: CardTheme(
                elevation: 1,
                margin: const EdgeInsets.only(top: 15),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
              ),
              buttonTheme: const LoginButtonTheme(
                splashColor: Colors.deepOrange,
                backgroundColor: Colors.blue,
                elevation: 1.0,
                highlightElevation: 1.0,
              ),
            ),
            userValidator: (valueUser) {
              if (valueUser.toString().isEmpty) {
                return 'Kode cabang tidak boleh kosong';
              }
              if(valueUser.toString() != branchString){
                return 'Tidak ada akses ke kode cabang $valueUser';
              }
            },
            passwordValidator: (valuePass) {
              if (valuePass.toString().isEmpty) {
                return 'Password tidak boleh kosong';
              } else if (valuePass!.length <= 2) {
                return 'Password minimal 3 Karakter';
              }
            },
            onRecoverPassword: (string) {
              UtilsDialog.flushBarToastMessage('Dalam pengembangan', context);
            },
            onLogin: (loginData) async {
              bool isConnected = await connection.checkInternetConnectivity();
              if (isConnected) {
                Map<String, dynamic> data = {
                  'cbranch': loginData.name,
                  'password': loginData.password,
                };
                try {
                  if(mounted){
                    var result = await loginViewModel.loginApi(data, context);
                    UserModel response = UserModel.fromJson(result);
                    if (response.status == '1') {
                      return null;
                    } else {
                      return response.pesan;
                    }
                  }
                } catch (e) {
                  return 'Gagal Login.';
                }
              } else {
                return 'Tidak ada koneksi';
              }
            },
            onSubmitAnimationCompleted: () {
              Navigator.pushNamed(context, RoutesName.home);
            },
          ),
        ],
      ),
    );
  }
}
