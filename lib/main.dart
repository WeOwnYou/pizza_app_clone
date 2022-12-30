import 'package:dodo_clone/runner.dart';
import 'package:dodo_clone/src/config/app_config.dart';
import 'package:dodo_clone/src/config/debug_options.dart';
import 'package:dodo_clone/src/config/environment/build_types.dart';
import 'package:dodo_clone/src/config/environment/environment.dart';
import 'package:dodo_clone/src/config/urls.dart';

void main() {
  Environment.init(
    buildType: BuildType.debug,
    config: AppConfig(
      url: Url.testUrl,
      debugOptions: const DebugOptions(
        debugShowCheckedModeBanner: true,
      ),
    ),
  );
  run(Url.testUrl);
}
