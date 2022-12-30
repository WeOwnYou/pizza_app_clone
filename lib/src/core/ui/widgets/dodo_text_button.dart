import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:flutter/material.dart';

class DodoTextButton extends StatelessWidget {
  final String text;
  final double? size;
  final VoidCallback? onTap;
  const DodoTextButton({required this.text, this.onTap, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.mainTextOrange,
          fontWeight: FontWeight.w600,
          fontSize: size,
        ),
      ),
    );
  }
}
