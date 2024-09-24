import 'package:connectivity_plus/connectivity_plus.dart' as cp;
import 'package:taakitecture/taakitecture.dart';

class WebNetworkInfo implements INetworkInfo {
  @override
  Future<bool> isConnected() async {
    final connectivityResult = await cp.Connectivity().checkConnectivity();
    if (connectivityResult == cp.ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == cp.ConnectivityResult.mobile) {
      return true;
    } else {
      return false;
    }
  }
}
