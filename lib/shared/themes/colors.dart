import 'package:flutter/material.dart';

abstract class CustomColors {
  CustomColors._();
  static const Color vividGreen49 = Color(0xFF9DD549);
  static const Color darkGreen28 = Color(0xFF437028);
  static const Color creamyWhite = Color(0xFFFFFDE7);
  static const LinearGradient gradientGreen = LinearGradient(
    begin: Alignment(0.99, -0.13),
    end: Alignment(-0.99, 0.13),
    colors: [Color(0xE59DD549), Color(0xFF437028)],
  );
}
