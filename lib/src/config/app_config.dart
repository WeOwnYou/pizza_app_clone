import 'package:dodo_clone/src/config/debug_options.dart';

class AppConfig {
  final String url;
  final DebugOptions debugOptions;

  AppConfig({
    required this.url,
    required this.debugOptions,
  });

  AppConfig copyWith({
    String? url,
    DebugOptions? debugOptions,
  }) {
    return AppConfig(
      url: url ?? this.url,
      debugOptions: debugOptions ?? this.debugOptions,
    );
  }
}
