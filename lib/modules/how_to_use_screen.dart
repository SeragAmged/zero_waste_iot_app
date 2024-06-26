import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zero_waste_iot_app/modules/classification_screen.dart';
import 'package:zero_waste_iot_app/shared/assets.dart';
import 'package:zero_waste_iot_app/shared/helpers/navigation_helper.dart';
import 'package:zero_waste_iot_app/shared/themes/colors.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Container(
      decoration: const BoxDecoration(gradient: CustomColors.gradientGreen),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   leading: null,

        //   title: Image.asset(
        //     Assets.imagesLogo,
        //     width: 100,
        //     height: 50,
        //     fit: BoxFit.fill,
        //   ),
        // ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  Assets.imagesHowToUse,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image.asset(
                    Assets.imagesLogo,
                    width: 100,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            MaterialButton(
              onPressed: () {
                navigateTo(context, const ClassificationScreen());
              },
              elevation: 0,
              color: const Color(0xFFFFFDE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Start',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9DD549),
                  fontSize: 30,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
