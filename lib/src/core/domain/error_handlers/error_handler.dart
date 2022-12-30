abstract class ErrorHandler {
  /// This method have to handle of passed error and optional [StackTrace].
  void handleError(Object error, {StackTrace? stackTrace});
}
