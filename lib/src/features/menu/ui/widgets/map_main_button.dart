import 'package:flutter/material.dart';

class MapMainButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  const MapMainButton({required this.icon, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
        ),
        child: icon,
      ),
    );
  }
}
