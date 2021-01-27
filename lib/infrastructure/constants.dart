import 'package:flutter/material.dart';

class Constants {
  static const double smallSpace = 12.0;
  static const double mediumSpace = 24.0;
  static const double largeSpace = 32.0;
  static const double extraLargeSpace = 48.0;
  static const double smallFontSize = 14;
  static const double regularFontSize = 18;
  static const double mediumFontSize = 24;
  static const double largeFontSize = 32;
  static const Widget SMALL_WIDTH_BOX = SizedBox(width: smallSpace);
  static const Widget MEDIUM_WIDTH_BOX = SizedBox(width: mediumSpace);
  static const Widget LARGE_WIDTH_BOX = SizedBox(width: largeSpace);
  static const Widget XL_WIDTH_BOX = SizedBox(width: extraLargeSpace);
  static const Widget SMALL_HEIGHT_BOX = SizedBox(height: smallSpace);
  static const Widget MEDIUM_HEIGHT_BOX = SizedBox(height: mediumSpace);
  static const Widget LARGE_HEIGHT_BOX = SizedBox(height: largeSpace);
  static const Widget XL_HEIGHT_BOX = SizedBox(height: extraLargeSpace);
  static const Color COR_MOSTARDA = Color(0xFFFFBA00);
  static const Color COR_VINHO = Color(0xFF360E0E);
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(10);
}
