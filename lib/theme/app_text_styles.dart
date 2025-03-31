import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle heading = GoogleFonts.bitter(
    fontSize: 36,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle subheading = GoogleFonts.bitter(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle label = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
