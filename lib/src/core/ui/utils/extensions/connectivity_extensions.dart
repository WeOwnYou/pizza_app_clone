import 'package:connectivity_plus/connectivity_plus.dart';

extension CheckConnection on ConnectivityResult? {
  bool get hasInternet {
    switch (this) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
      case ConnectivityResult.vpn:
        return true;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.none:
      default:
        return false;
    }
  }
}
