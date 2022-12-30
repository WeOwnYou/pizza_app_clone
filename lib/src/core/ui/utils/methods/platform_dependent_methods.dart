import 'dart:async';
import 'dart:io' show Platform;

abstract class PlatformDependentMethod {
  static Future<T?>? callFutureByPlatform<T>({
    Future<T?> Function()? androidMethod,
    Future<T?> Function()? iosMethod,
  }) async {
    if (Platform.isAndroid) {
      return androidMethod?.call();
    } else if (Platform.isIOS) {
      return iosMethod?.call();
    } else {
      throw Exception('unhandled error');
    }
  }
}
