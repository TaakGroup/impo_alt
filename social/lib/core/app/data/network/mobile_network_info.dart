import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:taakitecture/taakitecture.dart';

class MobileNetworkInfo implements INetworkInfo {

  @override
  Future<bool> isConnected() async => await InternetConnectionChecker().hasConnection;
}
