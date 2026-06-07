import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final TextScaler? textScaler;
  final String? semanticsLabel;
  final StrutStyle? strutStyle;
  final Locale? locale;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final Color? backgroundColor;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final List<Shadow>? shadows;
  final List<FontFeature>? fontFeatures;
  final Paint? foreground;
  const CustomText(
    this.data, {
    super.key,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textScaler,
    this.semanticsLabel,
    this.strutStyle,
    this.locale,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.fontFamily,
    this.fontFamilyFallback,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.backgroundColor,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.shadows,
    this.fontFeatures,
    this.foreground,
  }) : assert(
          color == null || foreground == null,
        );
  TextStyle? get _style {
    final hasStyle = color != null ||
        fontSize != null ||
        fontWeight != null ||
        fontStyle != null ||
        fontFamily != null ||
        fontFamilyFallback != null ||
        letterSpacing != null ||
        wordSpacing != null ||
        height != null ||
        backgroundColor != null ||
        decoration != null ||
        decorationColor != null ||
        decorationStyle != null ||
        decorationThickness != null ||
        shadows != null ||
        fontFeatures != null ||
        foreground != null;

    if (!hasStyle) return null;

    return TextStyle(
      color: foreground == null ? color : null,
      fontSize: fontSize?.sp,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      backgroundColor: backgroundColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      shadows: shadows,
      fontFeatures: fontFeatures,
      foreground: foreground,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: _style,
      textAlign: textAlign,
      textDirection: textDirection,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textScaler: textScaler,
      semanticsLabel: semanticsLabel,
      strutStyle: strutStyle,
      locale: locale,
    );
  }
}