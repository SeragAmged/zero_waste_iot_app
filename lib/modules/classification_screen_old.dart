// import 'dart:developer';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tflite_v2/tflite_v2.dart';
// import 'package:zero_waste_iot_app/shared/cubit/app_cubit.dart';
// import 'package:zero_waste_iot_app/shared/cubit/app_states.dart';
// import 'package:zero_waste_iot_app/shared/helpers/camera/camera_helper.dart';
// import 'package:zero_waste_iot_app/shared/themes/colors.dart';

// class ClassificationScreenOld extends StatefulWidget {
//   const ClassificationScreenOld({super.key});

//   @override
//   State<ClassificationScreenOld> createState() => _ClassificationScreenOldState();
// }

// class _ClassificationScreenOldState extends State<ClassificationScreenOld> {
//   @override
//   Widget build(BuildContext context) {
//     return !CameraHelper.controller.value.isInitialized
//         ? const SizedBox()
//         : BlocConsumer<AppCubit, AppStates>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               return Stack(
//                 alignment: Alignment.topCenter,
//                 children: [
//                   CameraPreview(CameraHelper.controller),
//                   Positioned(
//                     bottom: 30,
//                     child: GestureDetector(
//                       onTap: () => capture(),
//                       child: const Icon(
//                         Icons.camera,
//                         color: CustomColors.vividGreen49,
//                         size: 50,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//   }

//   late CameraImage cameraImage;
//   int imageCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     initTensorFlow();
//     CameraHelper.controller.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});

//       CameraHelper.controller.startImageStream((image) {
//         // cameraImage = image;
//         imageCount++;
//         if (imageCount % 10 == 0) {
//           imageCount = 0;
//           cameraImage = image;
//           // classification(image);
//         }
//       }).catchError((_) {
//         log(_.toString());
//       });
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             break;
//           default:
//             break;
//         }
//       }
//     });
//   }

//   // @override
//   // void dispose() {
//   //   CameraHelper.controller.dispose();
//   //   Tflite.close();
//   //   super.dispose();
//   // }

//   Future<void> initTensorFlow() async {
//     // ignore: unused_local_variable
//     String? model = await Tflite.loadModel(
//       model: "assets/ml/model.tflite",
//       labels: "assets/ml/labels.txt",
//       numThreads: 1, // defaults to 1
//       isAsset: true,
//       useGpuDelegate:
//           false, // defaults to false, set to true to use GPU delegate
//     );
//   }

//   void classification() async {
//     CameraImage image = cameraImage;
//     var recognitions = await Tflite.runModelOnFrame(
//         bytesList:
//             image.planes.map((plane) => plane.bytes).toList(), // required
//         imageHeight: image.height,
//         imageWidth: image.width,
//         imageMean: 127.5, // defaults to 127.5
//         imageStd: 127.5, // defaults to 127.5
//         rotation: 90, // defaults to 90, Android only
//         numResults: 2, // defaults to 5
//         threshold: 0.1, // defaults to 0.1
//         asynch: true // defaults to true
//         );
//     log(recognitions.toString());
//   }

//   void capture() async {
//     try {
//       classification();
//     } catch (e) {
//       log(e.toString());
//     }
//     setState(() {});
//   }
// }
