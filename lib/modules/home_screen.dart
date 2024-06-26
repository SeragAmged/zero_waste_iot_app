import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:zero_waste_iot_app/modules/how_to_use_screen.dart';
import 'package:zero_waste_iot_app/shared/assets.dart';
import 'package:zero_waste_iot_app/shared/helpers/navigation_helper.dart';
import 'package:zero_waste_iot_app/shared/helpers/responsive/context_width_extension.dart';
import 'package:zero_waste_iot_app/shared/themes/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    const fixedScannerOverlay = FixedScannerOverlay(borderColor: Colors.white);
    return Container(
      decoration: const BoxDecoration(gradient: CustomColors.gradientGreen),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    ReaderWidget(
                      
                      onScan: (Code code) async => sendQrCodeToken(code),
                      onScanFailure: (Code? code) => toastTryAgain(),
                      lensDirection: CameraLensDirection.front,
                      resolution: ResolutionPreset.high,
                      scanDelay: const Duration(seconds: 1),
                      showToggleCamera: false,
                      showGallery: false,
                      showFlashlight: false,
                      tryRotate: true,
                      cropPercent: 0,
                      scannerOverlay: fixedScannerOverlay,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Image.asset(
                            Assets.imagesLogo,
                            width: 100,
                            height: 50,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text.rich(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 3.60,
                              ).responsive(context),
                              textAlign: TextAlign.center,
                              const TextSpan(
                                children: [
                                  TextSpan(text: 'Please Scan Your Phone '),
                                  TextSpan(
                                    text: 'QR',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  TextSpan(text: ' to Link'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: VerticalDivider(
                  color: Colors.white,
                  indent: 60,
                  endIndent: 60,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Download App From Here',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w700,
                        height: 5,
                        letterSpacing: 3.60,
                      ).responsive(context),
                    ),
                    const Spacer(),
                    Image.asset(
                      Assets.imagesQrImage,
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    const Spacer(),
                    MaterialButton(
                      onPressed: () {
                        navigateTo(context, const HowToUseScreen());
                      },
                      elevation: 0,
                      color: const Color(0xFFFFFDE7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Start Without Account',
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
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toastTryAgain() => log("failed");

  void sendQrCodeToken(Code code) async => log('code: ${code.text}');
}
