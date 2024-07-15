import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final int? maxLine;

  const AppFont(
    this.text, {
    super.key,
    this.color = Colors.white,
    this.align,
    this.size,
    this.fontWeight,
    this.decoration,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLine,
      style: GoogleFonts.notoSans(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}
