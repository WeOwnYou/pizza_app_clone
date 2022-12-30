import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:flutter/material.dart';

class CorporateButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final double widthFactor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isActive;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const CorporateButton({
    required this.isActive,
    this.onTap,
    required this.child,
    required this.widthFactor,
    this.backgroundColor,
    this.foregroundColor,
    Key? key,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Padding(
        padding: margin ?? const EdgeInsets.symmetric(vertical: 15.0),
        child: MaterialButton(
          disabledColor: AppColors.secondBgOrange,
          onPressed: isActive ? onTap : null,
          child: child,
          elevation: 0,
          color: backgroundColor ??
              (isActive ? AppColors.mainBgOrange : AppColors.mainTextOrange),
          textColor: foregroundColor ??
              (isActive ? Colors.white : AppColors.mainTextOrange),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
