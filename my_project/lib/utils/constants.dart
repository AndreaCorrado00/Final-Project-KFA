import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A class of constans that are used trought the code
class Constants {
  // COLORS
  static const primaryColor = Color.fromARGB(255, 3, 204, 0);
  static const primaryLightColor = Color.fromARGB(255, 235, 235, 235);
  static const secondaryColor = Color.fromARGB(255, 0, 130, 106);
  static const secondarylightColor = Color.fromARGB(255, 238, 255, 0);
  static const thirdColor = Color.fromARGB(136, 129, 255, 156);
  static const myfontFamily = 'Roboto';

  // TEXT STYLES
  static final TextButtonStyle_HomePage = GoogleFonts.roboto(
    fontSize: 25.0,
    color: secondaryColor,
  );

  static final TextButtonStyle_Drawer = TextButton.styleFrom(
      foregroundColor: secondarylightColor,
      shadowColor: secondaryColor,
      fixedSize: const Size(250, 50),
      alignment: const Alignment(-0.95, 0),
      textStyle: const TextStyle(
        fontFamily: myfontFamily,
        fontSize: 20.0,
      ));

  static final TextButtonStyle_Alert = TextButton.styleFrom(
      foregroundColor: secondaryColor,
      shadowColor: secondarylightColor,
      textStyle: const TextStyle(
        fontFamily: myfontFamily,
        fontSize: 15.0,
      ));

  static final double defaultPadding = 16.0;

  
}
