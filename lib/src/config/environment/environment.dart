import 'package:dodo_clone/src/config/environment/build_types.dart';
import 'package:flutter/cupertino.dart';

class Environment<T> extends Listenable {
  static Environment? _instance;
  final BuildType _currentBuildType;
  ValueNotifier<T> _config;

  T get config => _config.value;
  set config(T c) => _config.value = c;

  BuildType get buildType => _currentBuildType;

  bool get isDebug => _currentBuildType == BuildType.debug;
  bool get isRelease => _currentBuildType == BuildType.release;

  Environment._(this._currentBuildType, T config)
      : _config = ValueNotifier(config);

  factory Environment.instance() => _instance as Environment<T>;

  @override
  void addListener(VoidCallback listener) {
    _config.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _config.removeListener(listener);
  }

  static void init<T>({
    required BuildType buildType,
    required T config,
  }) {
    _instance ??= Environment<T>._(buildType, config);
  }
}
