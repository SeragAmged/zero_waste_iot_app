import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_waste_iot_app/helper/image_classification_helper.dart';
import 'package:zero_waste_iot_app/modules/result_screen/result_screen.dart';
import 'package:zero_waste_iot_app/shared/cubit/app_cubit.dart';
import 'package:zero_waste_iot_app/shared/cubit/app_states.dart';
import 'package:zero_waste_iot_app/shared/helpers/camera/camera_helper.dart';
import 'package:zero_waste_iot_app/shared/helpers/navigation_helper.dart';
import 'package:zero_waste_iot_app/shared/themes/colors.dart';
import 'package:zero_waste_iot_app/shared/variabels.dart';

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  @override
  String? prediction;

  @override
  Widget build(BuildContext context) {
    return !CameraHelper.controller.value.isInitialized
        ? const SizedBox()
        : BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                body: Container(
                  decoration:
                      const BoxDecoration(gradient: CustomColors.gradientGreen),
                  child: Row(
                    children: [
                      Expanded(
                        // flex: 2,
                        child: CameraPreview(CameraHelper.controller),
                      ),
                      // Expanded(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Image.asset(Assets.imagesBins),
                      //       const SizedBox(
                      //         height: 20,
                      //       ),
                      //       if (prediction != null)
                      //         Text(
                      //           prediction!,
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: prediction == "paper"
                      //                 ? const Color(0xFFFFB800)
                      //                 : prediction == "plastic"
                      //                     ? Colors.red
                      //                     : Colors.green,
                      //             fontSize: 40,
                      //             fontFamily: 'Outfit',
                      //             fontWeight: FontWeight.w800,
                      //             height: 0.01,
                      //             letterSpacing: 8,
                      //           ),
                      //         )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            },
          );
  }

  late CameraImage cameraImage;
  List<Map<String, double>> imageList = [];
  late ImageClassificationHelper imageClassificationHelper;
  bool _isProcessing = false;
  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
    initCamera();
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper.initHelper();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        CameraHelper.controller.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!CameraHelper.controller.value.isStreamingImages) {
          await CameraHelper.controller.startImageStream(imageAnalysis);
        }
        break;
      default:
    }
  }

  // init camera
  initCamera() {
    CameraHelper.controller.initialize().then((value) {
      CameraHelper.controller.startImageStream(imageAnalysis);
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> imageAnalysis(CameraImage cameraImage) async {
    // if image is still analyze, skip this frame
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    var result =
        await imageClassificationHelper.inferenceCameraFrame(cameraImage);
    _isProcessing = false;
    if (imageList.length < 5) {
      imageList.add(result);
    }
    if (imageList.length == 5) {
      List<String> maxClasses = [];

      for (var image in imageList) {
        if (image.isNotEmpty) {
          String highestPrediction = image.keys.first;
          double maxValue = image[highestPrediction]!;

          image.forEach((key, value) {
            if (value > maxValue) {
              highestPrediction = key;
              maxValue = value;
            }
          });

          maxClasses.add(highestPrediction);
        }
      }

      prediction = vote(maxClasses);
      log("my max class is $prediction");

      imageList.clear();
      firebaseuploadImage = await CameraHelper.controller.takePicture();
      navigateAndFinish(
          context,
          ResultScreen(
            prediction: prediction!,
          ));
      prediction = null;
      if (mounted) {
        setState(() {});
      }
    }
  }
}

String vote(List<String> list) {
  Map<String, int> countMap = {};

  // Count the occurrences of each element
  for (String element in list) {
    if (countMap.containsKey(element)) {
      countMap[element] = countMap[element]! + 1;
    } else {
      countMap[element] = 1;
    }
  }

  // Find the element with the highest count
  String? mostRepeatedElement;
  int maxCount = 0;
  countMap.forEach((key, value) {
    if (value > maxCount) {
      maxCount = value;
      mostRepeatedElement = key;
    }
  });

  return mostRepeatedElement!;
}
