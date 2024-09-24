import 'package:package_info_plus/package_info_plus.dart';
import '../i_package_info.dart';

class PackageInfoPlus implements IPackageInfo{
  @override
  Future<String> getSoftwareVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

}