import 'package:url_launcher/url_launcher.dart';

import '../i_url_launcher.dart';

class UrlLauncher extends IUrlLauncher {
  @override
  launchPhone(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  launchWeb(String path) async {
    final Uri url = Uri.parse(path);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
