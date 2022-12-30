import 'package:dodo_clone/src/core/domain/error_handlers/default_error_handler.dart';
import 'package:dodo_clone/src/core/domain/error_handlers/error_handler.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:flutter/foundation.dart';

class AppScope implements IAppScope {
  late final ErrorHandler _errorHandler;
  late final VoidCallback _applicationRebuilder;
  late final AppRouter _router;

  @override
  VoidCallback get applicationRebuilder => _applicationRebuilder;

  @override
  ErrorHandler get errorHandler => _errorHandler;

  @override
  AppRouter get router => _router;

  AppScope({required VoidCallback applicationRebuilder})
      : _applicationRebuilder = applicationRebuilder {
    _errorHandler = DefaultErrorHandler();
    _router = AppRouter.instance();
  }
}

abstract class IAppScope {
  /// Interface for handle error in business logic.
  ErrorHandler get errorHandler;

  /// Callback to rebuild the whole application.
  VoidCallback get applicationRebuilder;

  /// Class that coordinates navigation for the whole app.
  AppRouter get router;
}
