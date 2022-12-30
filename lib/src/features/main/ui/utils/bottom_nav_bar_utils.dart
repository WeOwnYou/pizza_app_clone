import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class BottomNavBarBlock {
  final String label;
  final Widget icon;
  final PageRouteInfo pageRouteInfo;

  const BottomNavBarBlock({
    required this.label,
    required this.icon,
    required this.pageRouteInfo,
  });
}
