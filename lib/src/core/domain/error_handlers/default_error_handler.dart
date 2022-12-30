import 'package:dodo_clone/src/core/domain/error_handlers/error_handler.dart';

class DefaultErrorHandler implements ErrorHandler {
  @override
  void handleError(Object error, {StackTrace? stackTrace}) {
    // ignore: avoid_print
    print(error);
  }
}
