import 'package:flutter/material.dart';
import 'package:zero_waste_iot_app/shared/themes/colors.dart';

abstract class CustomTextStyle {
  static const TextStyle regular80 = TextStyle(
    color: Colors.white,
    fontSize: 80,
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w400,
    height: 0.01,
    letterSpacing: 8,
  );

  static const TextStyle bold45 = TextStyle(
    color: CustomColors.vividGreen49,
    fontSize: 45,
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w700,
    height: 0.02,
    letterSpacing: 2.25,
  );

  static const TextStyle extraBold80 = TextStyle(
    color: Color(0xFFFFB800),
    fontSize: 80,
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w800,
    height: 0.01,
    letterSpacing: 8,
  );
}
