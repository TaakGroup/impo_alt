import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkConnectionInternet() async {
  var connectivityResult = await (new Connectivity().checkConnectivity());
  return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
}
