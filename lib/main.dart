import 'dart:async';
import 'package:sas_hima/constant/const_preference.dart';
import 'package:sas_hima/constant/const_string.dart';
import 'package:sas_hima/services/routes/routes.dart';
import 'package:sas_hima/services/service_splash.dart';
import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/utils/SessionManager.dart';
import 'package:sas_hima/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  setupServices();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appDescString,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: Routes.generateRoute,
      home: const SplashPage(title: appDescString),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashService splashService = SplashService();
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    Timer(const Duration(seconds: 3), () => splashService.checkAuthentication(context));
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      SessionManager userPreference = SessionManager();
      userPreference.setPreference(ConstPreference.CVERSION, _packageInfo.version);
      userPreference.setPreference(ConstPreference.CCODEVERSION, _packageInfo.buildNumber);
    });
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(logoImage),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
          bottom: 40,
          child: Container(
              width: width,
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text('Support by'),
                  Image.asset(
                    logocomp,
                    width: 120,
                    height: 40,
                  ),
                  const SizedBox(height: 10,),
                  Text('Version ${_packageInfo.version}'),
                ],
              ))),
        ],
      ),
    );
  }
}
