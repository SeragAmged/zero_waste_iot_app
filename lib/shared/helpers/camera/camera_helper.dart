import 'package:camera/camera.dart';

class CameraHelper {
  static late CameraController controller;
  static Future<void> init() async {
    dynamic cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.low,
        imageFormatGroup: ImageFormatGroup.yuv420);
  }
}
