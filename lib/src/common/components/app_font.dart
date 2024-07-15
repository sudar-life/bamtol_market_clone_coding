import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final TextAlign? align;
  final FontWeight? fontWeight;

  const AppFont(
    this.text, {
    super.key,
    this.color = Colors.white,
    this.align,
    this.size,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.notoSans(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
