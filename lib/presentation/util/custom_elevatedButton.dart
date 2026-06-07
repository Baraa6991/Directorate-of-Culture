import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;

  // ─── الشكل ───────────────────────────────────
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? overlayColor;
  final Color? shadowColor;
  final double? elevation;

  // ─── الحد ────────────────────────────────────
  final Color? borderColor;
  final double borderWidth;

  // ─── الحجم ───────────────────────────────────
  final double? paddingHorizontal;
  final double? paddingVertical;
  final Size? fixedSize;
  final Size? minimumSize;

  // ─── السلوك ──────────────────────────────────
  final bool autofocus;

  const CustomElevatedButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.child,
    this.radius = 8,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.shadowColor,
    this.elevation,
    this.borderColor,
    this.borderWidth = 1.0,
    this.paddingHorizontal,
    this.paddingVertical,
    this.fixedSize,
    this.minimumSize,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      autofocus: autofocus,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        overlayColor: overlayColor,
        shadowColor: shadowColor,
        elevation: elevation,
        fixedSize: fixedSize,
        minimumSize: minimumSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: borderWidth)
            : null,
        padding: fixedSize == null
            ? EdgeInsets.symmetric(
                horizontal: paddingHorizontal ?? 24,
                vertical: paddingVertical ?? 14,
              )
            : null,
      ),
      child: child,   
    );
  }
}
