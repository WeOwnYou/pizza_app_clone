import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    iconTheme: const IconThemeData(color: AppColors.mainIconGrey),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      color: Colors.white,
      foregroundColor: Colors.black,
      actionsIconTheme: IconThemeData(
        color: AppColors.mainTextOrange,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      // backgroundColor: Colors.grey.shade100.withOpacity(0.9),
      selectedItemColor: AppColors.mainBgOrange,
      unselectedItemColor: AppColors.mainIconGrey,
    ),
  );

  static CupertinoTheme iosLight(BuildContext context, Widget? child) =>
      CupertinoTheme(
        data: const CupertinoThemeData(
          primaryColor: AppColors.mainBgOrange,
          scaffoldBackgroundColor: Colors.white,
        ),
        child: child!,
      );

  static final dart = ThemeData.dark();
}
