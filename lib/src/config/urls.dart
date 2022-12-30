import 'package:dodo_clone/src/config/app_config.dart';
import 'package:dodo_clone/src/config/environment/environment.dart';

abstract class Url {
  static String get testUrl => 'http://kotlyarov.3jz.ru/dodo_clone';
  static String get prodUrl => 'http://kotlyarov.3jz.ru/dodo_clone';
  static String get baseUrl => Environment<AppConfig>.instance().config.url;
}
