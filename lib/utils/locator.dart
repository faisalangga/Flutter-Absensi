import 'package:sas_hima/services/Recognition/camera_service.dart';
import 'package:sas_hima/services/Recognition/face_detector.dart';
import 'package:sas_hima/services/Recognition/mlservice.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  locator.registerLazySingleton<MLService>(() => MLService());
}