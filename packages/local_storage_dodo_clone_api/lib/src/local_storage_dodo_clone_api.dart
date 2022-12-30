import 'package:local_storage_dodo_clone_api/src/hive_provider.dart';
import 'package:local_storage_dodo_clone_api/src/tokens_storage.dart';

class LocalStorageDodoCloneApi {
  HiveProvider get hiveProvider => HiveProvider.instance;
  TokensStorage get tokensStorage => TokensStorage.instance;
}
