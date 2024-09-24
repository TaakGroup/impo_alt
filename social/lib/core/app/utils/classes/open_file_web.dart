import '../../utils/helper/html_mock.dart' if (dart.library.html) 'dart:html' as html;

class OpenFileWeb {
  static get openFile => html.window.open;
}
