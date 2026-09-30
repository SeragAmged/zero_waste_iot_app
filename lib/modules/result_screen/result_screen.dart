import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zero_waste_iot_app/modules/classification_screen.dart';
import 'package:zero_waste_iot_app/modules/home_screen.dart';
import 'package:zero_waste_iot_app/modules/result_screen/default_dialog.dart';
import 'package:zero_waste_iot_app/modules/result_screen/logic.dart';
import 'package:zero_waste_iot_app/shared/assets.dart';
import 'package:zero_waste_iot_app/shared/helpers/navigation_helper.dart';
import 'package:zero_waste_iot_app/shared/helpers/socket_helper.dart';
import 'package:zero_waste_iot_app/shared/themes/colors.dart';
import 'package:zero_waste_iot_app/shared/themes/font_styles.dart';
import 'package:zero_waste_iot_app/shared/variabels.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key, required this.prediction});
  String prediction;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: CustomColors.gradientGreen),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 90),
          child: Column(
            children: [
              Image.asset(Assets.imagesBins),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 165),
                  Text(
                    "Plastic",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.prediction == "plastic"
                          ? Colors.red
                          : Colors.white,
                      fontSize: 30,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w800,
                      height: 0.01,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(width: 120),
                  Text(
                    "Paper",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.prediction == "paper"
                          ? const Color(0xFFFFB800)
                          : Colors.white,
                      fontSize: 30,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w800,
                      height: 0.01,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(width: 120),
                  Text(
                    "Metal",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.prediction == "metal"
                          ? Colors.green
                          : Colors.white,
                      fontSize: 30,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w800,
                      height: 0.01,
                      letterSpacing: 8,
                    ),
                  ),
                  // const SizedBox(width: 15),
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () {
                      navigateAndFinish(context, const ClassificationScreen());
                    },
                    elevation: 0,
                    color: const Color(0xFFFFFDE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Scan Again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9DD549),
                        fontSize: 30,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      navigateAndFinish(context, const HomeScreen());
                    },
                    elevation: 0,
                    color: const Color(0xFFFFFDE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Logout',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMyDialog();
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return DefaultDialog(
          title: "Was My Prediction Correct?",
          prediction: widget.prediction,
          buttons: [
            MaterialButton(
              onPressed: () {
                openBin(widget.prediction);
                Navigator.of(context).pop();
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => congratsDialog,
                );
              },
              elevation: 0,
              color: const Color(0xFFFFFDE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(30),
              child: const Text(
                'YES, Correct',
                textAlign: TextAlign.center,
                style: CustomTextStyle.dialogStyle,
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => DefaultDialog(
                    title: "No, So what is the right categoryI should add to?",
                    buttons: [
                      MaterialButton(
                        onPressed: () {
                          openBin('plastic');
                          widget.prediction = 'plastic';
                          setState(() {});
                          uploadImage(
                              image: firebaseuploadImage!,
                              fireStoragePath: "plastic/");

                          Navigator.of(context).pop();
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => congratsDialog,
                          );
                        },
                        elevation: 0,
                        color: const Color(0xFFFFFDE7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(30),
                        child: const Text(
                          'Plastic',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w700,
                            height: 0.02,
                            letterSpacing: 2.25,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          openBin('paper');
                          uploadImage(
                              image: firebaseuploadImage!,
                              fireStoragePath: "paper/");
                          widget.prediction = 'paper';
                          setState(() {});

                          Navigator.of(context).pop();
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => congratsDialog,
                          );
                        },
                        elevation: 0,
                        color: const Color(0xFFFFFDE7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(30),
                        child: const Text(
                          'Paper',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w700,
                            height: 0.02,
                            letterSpacing: 2.25,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          openBin('metal');
                          uploadImage(
                              image: firebaseuploadImage!,
                              fireStoragePath: "metal/");

                          widget.prediction = 'metal';
                          setState(() {});

                          Navigator.of(context).pop();
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => congratsDialog,
                          );
                        },
                        elevation: 0,
                        color: const Color(0xFFFFFDE7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(30),
                        child: const Text(
                          'Metal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w700,
                            height: 0.02,
                            letterSpacing: 2.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              elevation: 0,
              color: const Color(0xFFFFFDE7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(vertical: 30, horizontal: 100),
              child: const Text(
                'No',
                textAlign: TextAlign.center,
                style: CustomTextStyle.dialogStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  void openBin(String prediction) {
    final int binId = prediction == "paper"
        ? 1
        : prediction == "plastic"
            ? 2
            : 5;

    listenPrediction = binId;
    SocketHelper.socket.write(binId);
  }
}

const congratsDialog = DefaultDialog(
  title: "Thanks For Improving Your Coming Experience",
  buttons: [
    Stack(
      children: [
        Icon(
          Icons.circle,
          color: Colors.white,
          size: 200,
        ),
        Icon(
          Icons.check_circle,
          color: CustomColors.vividGreen49,
          size: 200,
        ),
      ],
    )
  ],
);

Future<String?> uploadImage({
  required XFile image,
  required String fireStoragePath,
}) async {
  try {
    final value = await FirebaseStorage.instance
        .ref()
        .child("$fireStoragePath/${Uri.file(image.path).pathSegments.last}")
        .putFile(File(image.path));

    final String downloadURL = await value.ref.getDownloadURL();

    return downloadURL;
  } catch (error) {
    return null;
  }
}
