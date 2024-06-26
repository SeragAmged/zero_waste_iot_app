
// import 'dart:developer';
// import 'dart:io';
// import 'dart:isolate';

// import 'package:camera/camera.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as image_lib;
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:zero_waste_iot_app/shared/helpers/camera/image_utils.dart';

// import 'isolate_inference.dart';

// class ImageClassificationHelper {
//   // static const modelPath = 'assets/models/mobilenet_quant.tflite';
//   // static const labelsPath = 'assets/models/labels.txt';
//   static const modelPath = 'assets/model.tflite';
//   static const labelsPath = 'assets/labels.txt';

//   late final Interpreter interpreter;
//   late final List<String> labels;
//   late final IsolateInference isolateInference;
//   late Tensor inputTensor;
//   late Tensor outputTensor;

//   // Load model
//   Future<void> _loadModel() async {
//     final options = InterpreterOptions();
//     // Use XNNPACK Delegate
//     options.addDelegate(XNNPackDelegate());
//     // Load model from assets
//     interpreter = await Interpreter.fromAsset(modelPath, options: options);
//     // Get tensor input shape [1, 224, 224, 3]
//     inputTensor = interpreter.getInputTensors().first;
//     // Get tensor output shape [1, 1001]
//     outputTensor = interpreter.getOutputTensors().first;

//     log('Interpreter loaded successfully');
//   }

//   // Load labels from assets
//   Future<void> _loadLabels() async {
//     final labelTxt = await rootBundle.loadString(labelsPath);
//     labels = labelTxt.split('\n');
//   }

//   Future<void> initHelper() async {
//     _loadLabels();
//     _loadModel();
//   }

// // Run inference
//   Future<void> runInference(
//     CameraImage cameraImage,
//   ) async {
//     image_lib.Image? img;
//     img = ImageUtils.convertCameraImage(cameraImage);

//     // resize original image to match model shape.
//     image_lib.Image imageInput = image_lib.copyResize(
//       img!,
//       width:224,
//       height: 224,
//     );

//     imageInput = image_lib.copyRotate(imageInput, angle: 90);

//     final imageMatrix = List.generate(
//       imageInput.height,
//       (y) => List.generate(
//         imageInput.width,
//         (x) {
//           final pixel = imageInput.getPixel(x, y);
//           return [pixel.r, pixel.g, pixel.b];
//         },
//       ),
//     );

//     // Tensor input [1, 224, 224, 3]
//     final input = [imageMatrix];
//     // Tensor output [1, 1001]
//     final output = [List<int>.filled(1001, 0)];

//     // Run inference
//     interpreter.run(input, output);

//     // Get first output tensor
//     final result = output.first;
//     // log(result.toString());
//     // Get first output tensor
//     int maxScore = result.reduce((a, b) => a + b);
//     // Set classification map {label: points}
//     var classification = <String, double>{};
//     for (var i = 0; i < result.length; i++) {
//       if (result[i] != 0) {
//         // Set label: points
//         classification[labels[i]] = result[i].toDouble() / maxScore.toDouble();
//       }
//     }
//     log(classification.toString());
//   }

//   // static void entryPoint(SendPort sendPort) async {
//   //   final port = ReceivePort();
//   //   sendPort.send(port.sendPort);

//   //   image_lib.Image? img;
//   //   if (isolateModel.isCameraFrame()) {
//   //     img = ImageUtils.convertCameraImage(isolateModel.cameraImage!);
//   //   }
//   //   // resize original image to match model shape.
//   //   image_lib.Image imageInput = image_lib.copyResize(
//   //     img!,
//   //     width: inputTensor.shape[1],
//   //     height: outputTensor.shape[2],
//   //   );

//   //   if (Platform.isAndroid && isolateModel.isCameraFrame()) {
//   //     imageInput = image_lib.copyRotate(imageInput, angle: 90);
//   //   }

//   //   final imageMatrix = List.generate(
//   //     imageInput.height,
//   //     (y) => List.generate(
//   //       imageInput.width,
//   //       (x) {
//   //         final pixel = imageInput.getPixel(x, y);
//   //         return [pixel.r, pixel.g, pixel.b];
//   //       },
//   //     ),
//   //   );

//   //   // Set tensor input [1, 224, 224, 3]
//   //   final input = [imageMatrix];
//   //   // Set tensor output [1, 1001]
//   //   final output = [List<int>.filled(4, 0)];
//   //   // // Run inference
//   //   Interpreter interpreter =
//   //       Interpreter.fromAddress(isolateModel.interpreterAddress);
//   //   interpreter.run(input, output);
//   //   // Get first output tensor
//   //   final result = output.first;
//   //   int maxScore = result.reduce((a, b) => a + b);
//   //   // Set classification map {label: points}
//   //   var classification = <String, double>{};
//   //   for (var i = 0; i < result.length; i++) {
//   //     if (result[i] != 0) {
//   //       // Set label: points
//   //       classification[isolateModel.labels[i]] =
//   //           result[i].toDouble() / maxScore.toDouble();
//   //     }
//   //   }
//   //   isolateModel.responsePort.send(classification);
//   // }

//   // Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
//   //   ReceivePort responsePort = ReceivePort();
//   //   isolateInference.sendPort
//   //       .send(inferenceModel..responsePort = responsePort.sendPort);
//   //   // get inference result.
//   //   var results = await responsePort.first;
//   //   return results;
//   // }

//   // // inference camera frame
//   // Future<Map<String, double>> inferenceCameraFrame(
//   //     CameraImage cameraImage) async {
//   //   var isolateModel = InferenceModel(cameraImage, null, interpreter.address,
//   //       labels, inputTensor.shape, outputTensor.shape);
//   //   return _inference(isolateModel);
//   // }

//   // Future<void> close() async {
//   //   isolateInference.close();
//   // }
// }
/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'isolate_inference.dart';

class ImageClassificationHelper {
  static const modelPath = 'assets/ml/model.tflite';
  static const labelsPath = 'assets/ml/labels.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late final IsolateInference isolateInference;
  late Tensor inputTensor;
  late Tensor outputTensor;

  // Load model
  Future<void> _loadModel() async {
    final options = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    // Use GPU Delegate
    // doesn't work on emulator
    // if (Platform.isAndroid) {
    //   options.addDelegate(GpuDelegateV2());
    // }

    // Use Metal Delegate
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1001]
    outputTensor = interpreter.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort
        .send(inferenceModel..responsePort = responsePort.sendPort);
    // get inference result.
    var results = await responsePort.first;
    return results;
  }

  // inference camera frame
  Future<Map<String, double>> inferenceCameraFrame(
      CameraImage cameraImage) async {
    var isolateModel = InferenceModel(cameraImage, null, interpreter.address,
        labels, inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }

  // inference still image
  // Future<Map<String, double>> inferenceImage(Image image) async {
  //   var isolateModel = InferenceModel(null, image, interpreter.address, labels,
  //       inputTensor.shape, outputTensor.shape);
  //   return _inference(isolateModel);
  // }

  Future<void> close() async {
    isolateInference.close();
  }
}