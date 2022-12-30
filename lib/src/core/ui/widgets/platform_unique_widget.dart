import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformUniqueWidget extends StatelessWidget {
  final WidgetBuilder _androidBuilder;
  final WidgetBuilder _iosBuilder;
  const PlatformUniqueWidget({
    required WidgetBuilder androidBuilder,
    required WidgetBuilder iosBuilder,
    super.key,
  })  : _androidBuilder = androidBuilder,
        _iosBuilder = iosBuilder;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidBuilder(context);
      case TargetPlatform.iOS:
        return _iosBuilder(context);
      case TargetPlatform.fuchsia:
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
