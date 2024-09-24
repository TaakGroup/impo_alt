abstract class IDeviceInfo {
  Future<String> getDeviceModel();
  Future<int> getAndroidApiNumber();
}
