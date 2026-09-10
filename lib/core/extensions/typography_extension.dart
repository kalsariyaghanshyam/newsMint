import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

TextStyle poppins = GoogleFonts.poppins();

class FontFamily {
  static String poppins = "Poppins";
}

extension TextStyleExtensions on TextStyle {
  // Font Size
  TextStyle size(double v) => copyWith(fontSize: v);

  TextStyle get get8 => size(8);
  TextStyle get get9 => size(9);
  TextStyle get get10 => size(10);
  TextStyle get get11 => size(11);
  TextStyle get get12 => size(12);
  TextStyle get get13 => size(13);
  TextStyle get get14 => size(14);
  TextStyle get get15 => size(15);
  TextStyle get get16 => size(16);
  TextStyle get get17 => size(17);
  TextStyle get get18 => size(18);
  TextStyle get get19 => size(19);
  TextStyle get get20 => size(20);
  TextStyle get get22 => size(22);
  TextStyle get get24 => size(24);
  TextStyle get get28 => size(28);

  // Font Weight
  TextStyle weight(FontWeight v) => copyWith(fontWeight: v);

  TextStyle get light => weight(FontWeight.w300);
  TextStyle get regular => weight(FontWeight.w400);
  TextStyle get medium => weight(FontWeight.w500);
  TextStyle get semiBold => weight(FontWeight.w600);
  TextStyle get bold => weight(FontWeight.w700);

  // Text Color
  TextStyle textColor(Color v) => copyWith(color: v);

  TextStyle get black => textColor(AppColors.black);
  TextStyle get white => textColor(AppColors.white);
  TextStyle get primary => textColor(AppColors.primary);
  TextStyle get red => textColor(AppColors.errorColor);
  TextStyle get green => textColor(AppColors.successColor);
  TextStyle get grey => textColor(AppColors.grey);
  TextStyle get cyan => textColor(AppColors.cyanAccent);

  // Letter Spacing
  TextStyle letterSpace(double v) => copyWith(letterSpacing: v);

  TextStyle get space01 => letterSpace(0.1);
  TextStyle get space02 => letterSpace(0.2);
  TextStyle get space05 => letterSpace(0.5);

  // Opacity
  TextStyle opacity(double value) => copyWith(color: color?.withValues(alpha: value));
}
