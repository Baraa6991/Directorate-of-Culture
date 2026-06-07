import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final double? radius;
  final BoxShape shape;
  final Color? gradientColor1;
  final Color? gradientColor2;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final String? assetName;
  final BoxFit imageFit;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final Offset shadowOffset;
  final double? paddingAll;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? marginAll;
  final double? marginTop;
  final double? marginBottom;
  final double? marginLeft;
  final double? marginRight;
  final double? marginHorizontal;
  final double? marginVertical;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Widget? child;

  const CustomContainer({
    super.key,
    this.width,
    this.height,
    this.constraints,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.shape = BoxShape.rectangle,
    this.gradientColor1,
    this.gradientColor2,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    this.assetName,
    this.imageFit = BoxFit.cover,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffset = Offset.zero,
    this.paddingAll,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.paddingHorizontal,
    this.paddingVertical,
    this.marginAll,
    this.marginTop,
    this.marginBottom,
    this.marginLeft,
    this.marginRight,
    this.marginHorizontal,
    this.marginVertical,
    this.alignment,
    this.clipBehavior = Clip.none,
    this.transform,
    this.transformAlignment,
    this.child,
  }) : assert(
         color == null || (gradientColor1 == null && gradientColor2 == null),
         '⚠ لا تستخدم color مع gradient معاً.',
       );

  Gradient? get _gradient {
    if (gradientColor1 == null || gradientColor2 == null) return null;
    return LinearGradient(
      colors: [gradientColor1!, gradientColor2!],
      begin: gradientBegin,
      end: gradientEnd,
    );
  }

  List<BoxShadow>? get _shadow {
    if (shadowColor == null) return null;
    return [
      BoxShadow(
        color: shadowColor!,
        blurRadius: shadowBlurRadius?.r ?? 8.r,
        offset: shadowOffset,
      ),
    ];
  }

  EdgeInsetsGeometry? get _padding {
    if (paddingAll != null) return EdgeInsets.all(paddingAll!.r);
    if (paddingHorizontal != null || paddingVertical != null) {
      return EdgeInsets.symmetric(
        horizontal: paddingHorizontal?.w ?? 0,
        vertical: paddingVertical?.h ?? 0,
      );
    }
    if (paddingTop != null ||
        paddingBottom != null ||
        paddingLeft != null ||
        paddingRight != null) {
      return EdgeInsets.only(
        top: paddingTop?.h ?? 0,
        bottom: paddingBottom?.h ?? 0,
        left: paddingLeft?.w ?? 0,
        right: paddingRight?.w ?? 0,
      );
    }
    return null;
  }

  EdgeInsetsGeometry? get _margin {
    if (marginAll != null) return EdgeInsets.all(marginAll!.r);
    if (marginHorizontal != null || marginVertical != null) {
      return EdgeInsets.symmetric(
        horizontal: marginHorizontal?.w ?? 0,
        vertical: marginVertical?.h ?? 0,
      );
    }
    if (marginTop != null ||
        marginBottom != null ||
        marginLeft != null ||
        marginRight != null) {
      return EdgeInsets.only(
        top: marginTop?.h ?? 0,
        bottom: marginBottom?.h ?? 0,
        left: marginLeft?.w ?? 0,
        right: marginRight?.w ?? 0,
      );
    }
    return null;
  }

  BoxDecoration? get _decoration {
    final hasDecoration = color != null ||
        _gradient != null ||
        borderColor != null ||
        radius != null ||
        _shadow != null ||
        assetName != null ||
        shape != BoxShape.rectangle;

    if (!hasDecoration) return null;

    return BoxDecoration(
      color: _gradient == null ? color : null,
      gradient: _gradient,
      border: borderColor != null
          ? Border.all(
              color: borderColor!,
              width: borderWidth?.w ?? 1.w,
            )
          : null,
      borderRadius: shape == BoxShape.circle
          ? null
          : (radius != null ? BorderRadius.circular(radius!.r) : null),
      shape: shape,
      boxShadow: _shadow,
      image: assetName != null
          ? DecorationImage(image: AssetImage(assetName!), fit: imageFit)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: height?.h,
      constraints: constraints,
      padding: _padding,
      margin: _margin,
      alignment: alignment,
      decoration: _decoration,
      clipBehavior: clipBehavior,
      transform: transform,
      transformAlignment: transformAlignment,
      child: child,
    );
  }
}